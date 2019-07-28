#!/bin/sh
###############################################################################
#               _____                      _  ______ _____                    #
#              /  ___|                    | | | ___ \  __ \                   #
#              \ `--. _ __ ___   __ _ _ __| |_| |_/ / |  \/                   #
#               `--. \ '_ ` _ \ / _` | '__| __|    /| | __                    #
#              /\__/ / | | | | | (_| | |  | |_| |\ \| |_\ \                   #
#              \____/|_| |_| |_|\__,_|_|   \__\_| \_|\____/ Inc.              #
#                                                                             #
###############################################################################
#                                                                             #
#                       copyright 2018 by SmartRG, Inc.                       #
#                              Santa Barbara, CA                              #
#                                                                             #
###############################################################################
#                                                                             #
# Author: chad.monroe@smartrg.com, tim.hayes@smartrg.com                      #
#                                                                             #
# Purpose: Sample WLAN adapter for WAV500 driver lacking cfg80211 support     #
#                                                                             #
# NOTE: current ht/vht caps assume 4x4 cards (what the I350 REF has)          #
#                                                                             #
###############################################################################
. /lib/functions.sh
. /lib/functions/system.sh

append DRIVERS "intel"

#
# variables passed to config_intel_hostapd
#

channel=""
autochannel=""
country=""
txpower=""
hwmode=""
htmode=""

ssid="prplwrt"
key="prplpassword"
encryption="psk2"
mode=""
doth=""
bridge=""
bssid=""

#
# this is the second part ... load firmware and init wlan0 and wlan2 devices
#
detect_intel_init_devices() {

	echo "detect_intel_init_devices $@" > /dev/kmsg

	insmod /lib/modules/*/net/mtlk.ko ap=1,1 fastpath=1,1 ahb_off=1 2>> /dev/null

	echo "intel.sh: detect_intel_init_devices done " > /dev/kmsg
}

#
# this is the first part ... load root and then detect_intel_init_devices 
#
detect_intel_init() {
	sync
	sync
	cp -s /root/mtlk/images/*.bin /lib/firmware 2>> /dev/null

	# OK if this fails; some boards (like EVM) have EEPROM available on chip
	read_img wlanconfig /tmp/eeprom.tar.gz 2>> /dev/null
	tar xzf /tmp/eeprom.tar.gz -C /tmp 2>> /dev/null
	[ -e /tmp/cal_wlan0.bin ] && cp -s /tmp/cal_wlan0.bin /lib/firmware 2>> /dev/null
	[ -e /tmp/cal_wlan1.bin ] && cp -s /tmp/cal_wlan2.bin /lib/firmware 2>> /dev/null
	[ -e /tmp/cal_wlan2.bin ] && cp -s /tmp/cal_wlan4.bin /lib/firmware 2>> /dev/null

	# need one of these; default is included with WLAN driver
	[ -e /tmp/PSD.bin ] && cp -s /tmp/PSD.bin /lib/firmware 2>> /dev/null
	udevd_up=`ps | grep -c udevd` 2>> /dev/null
	[ $udevd_up -gt 1 ] || udevd --daemon 2>> /dev/null
	export COUNTRY=00
	crda 2>> /dev/null
	sync
	sync
	insmod /lib/modules/*/net/mtlkroot.ko 2>> /dev/null
	echo "intel.sh: detect_intel_init done" > /dev/kmsg
	detect_intel_init_devices
}

disable_intel() {

	echo "intel.sh: disable_intel() $@" > /dev/kmsg


	local device="$1"
	local pid=""
	local pidfile=""

 	case $device in
	wlan0) 
	pidfile="/var/run/hostapd_wlan0.pid"
	pid=$(cat /var/run/hostapd_wlan0.pid)
	if [ -z $pid ]; then
		# this happens on boot sometimes
		pid=$(ps | grep hostapd | grep wlan0 | awk '{print $3}')
	fi
	;;
	wlan2) 
	pidfile="/var/run/hostapd_wlan2.pid"
	pid=$(cat /var/run/hostapd_wlan2.pid)
	if [ -z $pid ]; then
		# this happens on boot sometimes
		pid=$(ps | grep hostapd | grep wlan2 | awk '{print $3}')
	fi
	;;
	*)
		echo "disable_intel unknown wifi device $device done" > /dev/kmsg
		return
	;;
	esac

	if [ -z $pid ]; then
		echo "disable_intel no pid done" > /dev/kmsg
		return
	fi

	kill $pid

	hostapd_state=$(ls $pidfile 2>>/dev/null)
	down_timeout=0
	while [ ! -z $hostapd_state ];
	do
		let down_timeout=$down_timeout+1
		if [ $down_timeout -gt 15 ]; then
			break;
		fi
		sleep 1
		hostapd_state=$(ls $pidfile 2>>/dev/null)
	done
	echo "disable_intel killed pid $pid down_timeout $down_timeout done" > /dev/kmsg
}

# power level definitions are not accurate.. working with Intel to fix
convert_power_level()
{
	# Define local parameters
	local txpower
	local power_level

	txpower=$1

	case $txpower in
		7|8|9)
			power_level=21
			;;
		10|11|12)
			power_level=18
			;;
		13|14|15)
			power_level=15
			;;
		16|17|18)
			power_level=12
			;;
		19|20|21)
			power_level=9
			;;
		22|23|24)
			power_level=6
			;;
		25|26|27)
			power_level=3
			;;
		28|29|30)
			power_level=0
			;;
		*)
			power_level=22
			;;
	esac

	echo $power_level
}

enable_intel() {

	echo "intel.sh: enable_intel() $@" > /dev/kmsg

	if_up=
	local device="$1"
	config_get vifs "$device" vifs

#
# get config params
#
	config_get autochannel "$device" autochannel
	config_get channel "$device" channel
	config_get txpower "$device" txpower
	config_get htmode "$device" htmode
	config_get country "$device" country

	for vif in $vifs; do
		local disabled

		config_get key "$vif" key
		config_get ssid "$vif" ssid
		config_get bridge "$vif" network
		config_get encryption "$vif" encryption
		config_get hidden "$vif" hidden 0
		bridge=br-$bridge
		config_get ifname "$vif" ifname
		config_get macaddr "$vif" macaddr
		local net_cfg xbridge
		net_cfg="$(find_net_config "$vif")"
		[ -z "$net_cfg" ] || {
			xbridge="$(bridge_interface "$net_cfg")"
			config_set "$vif" bridge "$xbridge"
			start_net "$ifname" "$net_cfg"
		}
		ifconfig $ifname hw ether $macaddr

		set_wifi_up "$vif" "$ifname"
	done

	case $device in
		wlan0)
			bssid=$(cat /sys/class/net/wlan0/address)	
			config_intel_hostapd_wlan0
		;;
		wlan2)
			bssid=$(cat /sys/class/net/wlan2/address)	
			config_intel_hostapd_wlan2
		;;
		*)
			echo "enable_intel unknown wifi device $device done" > /dev/kmsg
			return
		;;
	esac

	case $device in
		wlan0)
			if [[ -z "${PARAM_package}" ]]; then
				hostapd -B -P /var/run/hostapd_wlan0.pid /tmp/hostapd_wlan0.conf 
			else
				hostapd /tmp/hostapd_wlan0.conf &
			fi
		;;
		wlan2)
			if [[ -z "${PARAM_package}" ]]; then
				hostapd -B -P /var/run/hostapd_wlan2.pid /tmp/hostapd_wlan2.conf
			else
				hostapd /tmp/hostapd_wlan2.conf &
			fi
		;;
		*)
			echo "enable_intel unknown wifi device $device done" > /dev/kmsg
			return
		;;
	esac


	config_get ifname "$device" ifname
	sPowerSelection=$(convert_power_level $txpower)
	iwpriv $ifname sPowerSelection $sPowerSelection 

	ins=$(ppacmd getlan | grep wlan0)
	if [ $? -ne 0 ]; then
		ppacmd addlan -i wlan0
	fi
	ins=$(ppacmd getlan | grep wlan2)
	if [ $? -ne 0 ]; then
		ppacmd addlan -i wlan2
	fi

	echo "intel.sh: enable_intel $device done sPowerSelection $sPowerSelection" > /dev/kmsg
}

detect_intel_cfg() {

	# FIXME - get this from uboot or somewhere better
	BASE_MAC=$(cat /sys/class/net/eth1/address)
	if [ -z "$BASE_MAC" ]; then
		BASE_MAC="3C:90:66:AD:EA:D1"
	fi

	mac=$(macaddr_add $BASE_MAC 4)
cat <<EOF
config wifi-device 'wlan0'
	option type 'intel'
	option ifname 'wlan0'
	option txpower '24'
	option hwmode '11g'
	option htmode 'HT20'
	option country 'US'
	option frameburst '1'
	option maxassoc '32'
	option autochannel '1'
	option obss_coex '1'
	option channel '11'
	option disabled '0'
	option band 'b'

config wifi-iface 'i2g'
	option device 'wlan0'
	option ifname 'wlan0'
	option macaddr '${mac}'
	option network 'lan'
	option mode 'ap'
	option doth '1'
	option wmm '1'
	option wmf '1'
	option ssid '${ssid}'
	option key '${key}'
	option encryption '${encryption}'

EOF

	mac=$(macaddr_add $BASE_MAC 10)
cat <<EOF

config wifi-device 'wlan2'
	option type 'intel'
	option ifname 'wlan2'
	option txpower '22'
	option hwmode '11a'
	option htmode 'VHT80'
	option country 'US'
	option frameburst '1'
	option maxassoc '32'
	option autochannel '1'
	option channel '36'
	option disabled '0'
	option band 'a'

config wifi-iface 'i5g'
	option device 'wlan2'
	option ifname 'wlan2'
	option macaddr '${mac}'
	option network 'lan'
	option mode 'ap'
	option doth '1'
	option wmm '1'
	option wmf '1'
	option ssid '${ssid}'
	option key '${key}'
	option encryption '${encryption}'

config wifi-status 'status'
	option wlan '1'

EOF

}


config_intel_hostapd_wlan0_ht_capab() {

	local ht_capab="[TX-STBC][RX-STBC1][LDPC][MAX-AMSDU-7935]"

	case $htmode in 
	HT20)
	ht_capab=$(printf "%s%s" "[SHORT-GI-20]" $ht_capab)
	;;
	HT40)
		case "$channel" in
			"8"|"9"|"10"|"11"|"12"|"13")
				ht_capab=$(printf "%s%s" "[HT40-][SHORT-GI-40]" $ht_capab)
				;;
			"1"|"2"|"3")
				;;
			*)
				ht_capab=$(printf "%s%s" "[HT40+][SHORT-GI-40]" $ht_capab)
				;;
		esac
	;;
	esac

	if [ "$channel" = "acs_numbss" ]; then
		ht_capab="[HT40+][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][LDPC][MAX-AMSDU-7935]"
		return
	fi

	echo "$ht_capab"
}

config_intel_hostapd_wlan_channel() {
	local wlan_channel=$channel
	echo $wlan_channel
}


config_intel_hostapd_wpa() {
	local wlan_encryption=$1
	case $wlan_encryption in
	none)
	echo 0
	return
	;;
	esac
	echo 2
}

WPS_ENABLE=`uci get wireless.advanced.wps_button`
if [ "$WPS_ENABLE" == "1" ]; then
	WPS_ENABLE=2
else
	WPS_ENABLE=0
fi


config_intel_hostapd_wlan0() {
	echo "config_intel_hostapd_wlan0 $@" > /dev/kmsg
cat <<EOF > /tmp/hostapd_wlan0.conf
################ Physical radio parameters ################
interface=wlan0
driver=nl80211
logger_syslog=1
logger_syslog_level=2
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
###___Radio_parameters___###
country_code=${country}
hw_mode=g
ieee80211d=1
channel=$channel
preamble=1
beacon_int=100
ieee80211n=1
ht_capab=$(config_intel_hostapd_wlan0_ht_capab)
ht_tx_bf_capab=[IMPL-TXBF-RX][EXPL-COMPR-STEER][EXPL-COMPR-FB-FBACK-IMM][MIN-GROUP-124][CSI-BF-ANT-1][NONCOMPS-BF-ANT-1][COMPS-BF-ANT-3][CSI-MAX-ROWS-BF-1][CHE-SPACE-TIME-STR-1]
ht_rifs=1
ieee80211ac=0
vht_capab=[MAX-MPDU-11454][RXLDPC][SHORT-GI-80][TX-STBC-2BY1][RX-STBC-1][BF-ANTENNA-4][SOUNDING-DIMENSION-4][VHT-TXOP-PS][SU-BEAMFORMER][SU-BEAMFORMEE][MU-BEAMFORMER][MAX-A-MPDU-LEN-EXP7]
vendor_vht=1
ap_max_num_sta=128
acs_num_scans=1
obss_interval=300
#scan_passive_dwell=20
#scan_active_dwell=10
#scan_passive_total_per_channel=200
#scan_active_total_per_channel=20
channel_transition_delay_factor=5
#scan_activity_threshold=25
obss_beacon_rssi_threshold=-20
acs_numbss_info_file=/tmp/acs_numbss_info_wlan0.txt
acs_smart_info_file=/tmp/acs_smart_info_wlan0.txt
acs_history_file=/tmp/acs_history_wlan0.txt
assoc_rsp_rx_mcs_mask=1
ignore_40_mhz_intolerant=0
###___WMM_parameters___###
wmm_ac_be_aifs=3
wmm_ac_be_cwmin=4
wmm_ac_be_cwmax=10
wmm_ac_be_txop_limit=0
wmm_ac_bk_aifs=7
wmm_ac_bk_cwmin=4
wmm_ac_bk_cwmax=10
wmm_ac_bk_txop_limit=0
wmm_ac_vi_aifs=2
wmm_ac_vi_cwmin=3
wmm_ac_vi_cwmax=4
wmm_ac_vi_txop_limit=94
wmm_ac_vo_aifs=2
wmm_ac_vo_cwmin=2
wmm_ac_vo_cwmax=3
wmm_ac_vo_txop_limit=47
############## wlan0 VAP parameters #############
vendor_elements=dd050009860100
bssid=$bssid
ssid=${ssid}
ignore_broadcast_ssid=$hidden
###___AccessPoint_parameters___###
ap_isolate=0
dtim_period=2
ap_max_inactivity=60
max_num_sta=128
num_res_sta=0
qos_map_set=0,7,8,15,16,23,24,31,32,39,40,47,48,55,56,63
wmm_enabled=1
uapsd_advertisement_enabled=1
proxy_arp=1
macaddr_acl=0
gas_comeback_delay=0
enable_bss_load_ie=1
###___MBO_parameters___###
mbo=1
mbo_cell_aware=1
rrm_neighbor_report=1
bss_transition=1
mbo_pmf_bypass=1
interworking=1
access_network_type=0
###___11k_parameters___###
rrm_link_measurement=1
rrm_sta_statistics=1
rrm_channel_load=1
rrm_noise_histogram=1
rrm_beacon_report_passive=1
rrm_beacon_report_table=1
###___Security_parameters___###
auth_algs=1
eapol_key_index_workaround=0
eap_server=1
ieee80211w=1
assoc_sa_query_max_timeout=1000
assoc_sa_query_retry_timeout=201
###___WPS_parameters___###
wps_state=$WPS_ENABLE
ap_setup_locked=0
uuid=5d8ecf94-5c99-4df3-9f2d-8337b25e60c8
wps_pin_requests=/var/run/hostapd.pin-req
device_name=WLAN-ROUTER
manufacturer=Intel Corporation
model_name=GRX350_1600_MR_VDSL_LTE_SEC_GW_7
serial_number=AC9A96F46D30
device_type=6-0050F204-1
os_version=01020300
config_methods=virtual_display push_button virtual_push_button physical_push_button keypad
ap_pin=12345670
wps_cred_processing=2
wps_rf_bands=ag
pbc_in_m1=1
upnp_iface=br-lan
friendly_name=GRX350_1600_MR_VDSL_LTE_SEC_GW_7
manufacturer_url=http://www.intel.com
model_description=TR069 Gateway
wpa=$(config_intel_hostapd_wpa $encryption)
EOF
wpa=$(config_intel_hostapd_wpa $encryption)
if [ "$wpa" != 0 ]; then
cat <<EOF >> /tmp/hostapd_wlan0.conf
wpa_key_mgmt=WPA-PSK
wpa_passphrase=$key
wpa_group_rekey=3600
wpa_gmk_rekey=3600
wpa_pairwise=CCMP
EOF
fi
	echo "config_intel_hostapd_wlan0 done" > /dev/kmsg
}

config_intel_hostapd_wlan2_ht_capab() {

	local ht_capab="[TX-STBC][RX-STBC1][LDPC][MAX-AMSDU-7935]"

	case $htmode in 
	HT20|VHT20)
	ht_capab=$(printf "%s%s" "[SHORT-GI-20]" $ht_capab)
	;;
	HT40|VHT40)
		case "$channel" in
			"40"|"48"|"56"|"64"|"104"|"112"|"120"|"128"|"136"|"144"|"153"|"161")
				ht_capab=$(printf "%s%s" "[HT40-][SHORT-GI-40][SHORT-GI-20]" $ht_capab)
				;;
			165)
				ht_capab=$(printf "%s%s" "[SHORT-GI-20]" $ht_capab)
				;;
			*)
				ht_capab=$(printf "%s%s" "[HT40+][SHORT-GI-40][SHORT-GI-20]" $ht_capab)
				;;
		esac
	;;
	HT80|VHT80)
		case "$channel" in
			"40"|"48"|"56"|"64"|"104"|"112"|"120"|"128"|"136"|"144"|"153"|"161")
				ht_capab=$(printf "%s%s" "[HT40-][SHORT-GI-40][SHORT-GI-20]" $ht_capab)
				;;
			165)
				ht_capab=$(printf "%s%s" "[SHORT-GI-20]" $ht_capab)
				;;
			*)
				ht_capab=$(printf "%s%s" "[HT40+][SHORT-GI-40][SHORT-GI-20]" $ht_capab)
				;;
		esac
	;;
	esac

	echo "$ht_capab"
}


config_intel_hostapd_wlan2_vht_capab() {

	local vht_capab=""

	case "$channel" in
		165)
		echo "$vht_capab"
		return
		;;
	esac

	case $htmode in 
	VHT80)
	vht_capab="[MAX-MPDU-11454][RXLDPC][TX-STBC-2BY1][RX-STBC-1][SU-BEAMFORMER][SU-BEAMFORMEE][BF-ANTENNA-4][SOUNDING-DIMENSION-4][VHT-TXOP-PS][MU-BEAMFORMER][MAX-A-MPDU-LEN-EXP7]"
	vht_capab=$(printf "%s%s" "[SHORT-GI-80]" $vht_capab)
	;;
	esac

	echo "$vht_capab"
}

config_intel_hostapd_wlan2_vht_oper_chwidth() {


	case $htmode in 
	VHT80)
	echo 1
	return
	;;
	esac

	echo 0
}


config_intel_hostapd_wlan2_vht_idx() {
	local idx=0


	case "$channel" in
		36|40|44|48) idx=42 ;;
		52|56|60|64) idx=58 ;;
		100|104|108|112) idx=106 ;;
		116|120|124|128) idx=122 ;;
		132|136|140|144) idx=138 ;;
		149|153|157|161|165) idx=155 ;;
	esac


	case $htmode in 
	VHT80)
	;;
	*)
	idx=0
	;;
	esac

	echo "$idx"
}

config_intel_hostapd_wlan2() {
	echo "config_intel_hostapd_wlan2 $@" > /dev/kmsg
cat <<EOF > /tmp/hostapd_wlan2.conf
################ Physical radio parameters ################
interface=wlan2
driver=nl80211
logger_syslog=1
logger_syslog_level=2
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
###___Radio_parameters___###
country_code=${country}
hw_mode=a
ieee80211d=1
channel=$channel
preamble=1
beacon_int=100
ieee80211n=1
ht_capab=$(config_intel_hostapd_wlan2_ht_capab)
ht_tx_bf_capab=[IMPL-TXBF-RX][EXPL-COMPR-STEER][EXPL-COMPR-FB-FBACK-IMM][MIN-GROUP-124][CSI-BF-ANT-1][NONCOMPS-BF-ANT-1][COMPS-BF-ANT-3][CSI-MAX-ROWS-BF-1][CHE-SPACE-TIME-STR-1]
ht_rifs=1
ieee80211ac=1
vht_oper_chwidth=$(config_intel_hostapd_wlan2_vht_oper_chwidth)
vht_capab=$(config_intel_hostapd_wlan2_vht_capab)
vht_oper_centr_freq_seg0_idx=$(config_intel_hostapd_wlan2_vht_idx)
ap_max_num_sta=128
acs_num_scans=1
ieee80211h=1
obss_interval=0
acs_numbss_info_file=/tmp/acs_numbss_info_wlan2.txt
acs_smart_info_file=/tmp/acs_smart_info_wlan2.txt
acs_history_file=/tmp/acs_history_wlan2.txt
assoc_rsp_rx_mcs_mask=1
ignore_40_mhz_intolerant=0
###___WMM_parameters___###
wmm_ac_be_aifs=3
wmm_ac_be_cwmin=4
wmm_ac_be_cwmax=10
wmm_ac_be_txop_limit=0
wmm_ac_bk_aifs=7
wmm_ac_bk_cwmin=4
wmm_ac_bk_cwmax=10
wmm_ac_bk_txop_limit=0
wmm_ac_vi_aifs=2
wmm_ac_vi_cwmin=3
wmm_ac_vi_cwmax=4
wmm_ac_vi_txop_limit=94
wmm_ac_vo_aifs=2
wmm_ac_vo_cwmin=2
wmm_ac_vo_cwmax=3
wmm_ac_vo_txop_limit=47
############## wlan2 VAP parameters #############
vendor_elements=dd050009860100
bssid=$bssid
ssid=${ssid}
###___AccessPoint_parameters___###
ignore_broadcast_ssid=$hidden
ap_isolate=0
dtim_period=2
ap_max_inactivity=60
max_num_sta=128
num_res_sta=0
opmode_notif=1
qos_map_set=0,7,8,15,16,23,24,31,32,39,40,47,48,55,56,63
wmm_enabled=1
uapsd_advertisement_enabled=1
proxy_arp=1
macaddr_acl=0
gas_comeback_delay=0
enable_bss_load_ie=1
###___MBO_parameters___###
mbo=1
mbo_cell_aware=1
rrm_neighbor_report=1
bss_transition=1
mbo_pmf_bypass=1
interworking=1
access_network_type=0
###___11k_parameters___###
rrm_link_measurement=1
rrm_sta_statistics=1
rrm_channel_load=1
rrm_noise_histogram=1
rrm_beacon_report_passive=1
rrm_beacon_report_table=1
###___Security_parameters___###
auth_algs=1
eapol_key_index_workaround=0
eap_server=1
ieee80211w=1
assoc_sa_query_max_timeout=1000
assoc_sa_query_retry_timeout=201
###___WPS_parameters___###
wps_state=$WPS_ENABLE
ap_setup_locked=0
uuid=5d8ecf94-5c99-4df3-9f2d-8337b25e60c8
wps_pin_requests=/var/run/hostapd.pin-req
device_name=WLAN-ROUTER
manufacturer=Intel Corporation
model_name=GRX350_1600_MR_VDSL_LTE_SEC_GW_7
serial_number=AC9A96F46D30
device_type=6-0050F204-1
os_version=01020300
config_methods=virtual_display push_button virtual_push_button physical_push_button keypad
ap_pin=12345670
wps_cred_processing=2
wps_rf_bands=ag
pbc_in_m1=1
upnp_iface=br-lan
friendly_name=GRX350_1600_MR_VDSL_LTE_SEC_GW_7
manufacturer_url=http://www.intel.com
model_description=TR069 Gateway
wpa=$(config_intel_hostapd_wpa $encryption)
EOF
wpa=$(config_intel_hostapd_wpa $encryption)
if [ "$wpa" != 0 ]; then
cat <<EOF >> /tmp/hostapd_wlan2.conf
wpa_key_mgmt=WPA-PSK
wpa_passphrase=$key
wpa_group_rekey=3600
wpa_gmk_rekey=3600
wpa_pairwise=CCMP
EOF
fi

	echo "config_intel_hostapd_wlan2 done" > /dev/kmsg
}


config_intel_hostapd() {
	echo "config_intel_hostapd $@" > /dev/kmsg
	local ssbase=`/usr/srg/scripts/generate-default-ssid.sh`
	config_intel_hostapd_wlan0 
	config_intel_hostapd_wlan2
	echo "config_intel_hostapd done" > /dev/kmsg
}


detect_intel() {
	echo "detect_intel $@" > /dev/kmsg
	if [ -e /etc/config/wireless ] && [ -s /etc/config/wireless ]; then
		detect_intel_init
		echo "detect_intel cfg exists done" > /dev/kmsg
		return;
	fi
	detect_intel_cfg $@ > /etc/config/wireless
	detect_intel_init
	echo "detect_intel new cfg done" > /dev/kmsg
}


scan_intel() {
        local device="$1"
        local adhoc sta ap monitor mesh
        config_get vifs "$device" vifs
        for vif in $vifs; do
                config_get mode "$vif" mode
                case "$mode" in
                        adhoc|sta|ap|monitor|mesh)
                                append $mode "$vif"
                        ;;
                        *) echo "$device($vif): Invalid mode, ignored."; continue;;
                esac
        done
        config_set "$device" vifs "${ap:+$ap }${adhoc:+$adhoc }${sta:+$sta }${monitor:+$monitor }${mesh:+$mesh}"
}


#
# Manual testing
#
case "$1" in
	detect) detect_intel;;
	detect_init) detect_intel_init;;
	detect_cfg) detect_intel_cfg;;
	config_hostapd) config_intel_hostapd;;
	show) show_intel;;
	enable) 
		enable_intel $2;;
	scan) 
		scan_intel $2;;
	disable) 
		disable_intel $2;;
	*) ;;
esac
