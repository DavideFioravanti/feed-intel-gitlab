
UGW_PACKAGES:= \
        base-files-ugw dbtool pad webcgi websockets ugw-devm urlfilterd \
        klish klish-xml-files servd csd polld libcal lighttpd \
        libdeviceinfo libdyndns libethservices libfirewallnat libipv6 \
        liblanservices liblogd libmanagementserver libmultiwan libnetwork \
        libqos libsysservices libupgrade libusbhosts libuser libvoip libwlan \
        libwms libhsfapi hscli sl_upnp libmcastservices libugwhelper libdiagnostics \
        ltq-voip ltq-dect ltq-wlan-wave_5_x ltq-wlan-wave_5_x-rflib \
        fapi_wlan_vendor_wave fapi_wlan_common kmod-lantiq-wlan-wave-support_5_x \
        wwan libcellwan libumbim \
        iotivity iotivity-cpp iotivity-resource-directory-lib iotivity-oic-middle iotivity-resource-container-libiotivity-resource-container-sample \
        iotivity-resource-container-hue iotivity-example-garage iotivity-example-simple iotivity_DEBUG iotivity_SECURE libhanfun \
        libdevprioritization

OWRT_PACKAGES:=luci firewall luci-theme-openwrt base-files-owrt \
        owrt-qos-scripts owrt-mcast-scripts owrt-sys-scripts owrt-dsl-scripts owrt-ppa-scripts

DSL_CPE_PACKAGES:=dsl-cpe-api-vrx dsl-cpe-control-vrx dsl-cpe-fapi dsl-cpe-mei-vrx \
	dsl-vr11-firmware-xdsl kmod-dsl-cpe-mei-vrx kmod-vrx518_ep kmod-vrx518_tc_drv \
	vrx518_aca_fw vrx518_ppe_fw ugw-atm-oam

DSL_CPE_UGW_PACKAGE:=sl-dsl-cpe

DSL_CPE_GFAST_PACKAGES:=dsl-gfast-api-vrx618 dsl-gfast-drv-pciep dsl-gfast-drv-pmi dsl-gfast-fapi \
	dsl-gfast-init dsl-vrx618-firmware dti-pmi kmod-dsl-gfast-drv-pciep kmod-dsl-gfast-drv-pmi \
	dsl-gfast-drv-dp kmod-dsl-gfast-drv-dp sl-dsl-cpe-vrx618

GFAST_CO_PACKAGES:=dsl-vnx101-firmware dsl-gfast-api-vnx101 dsl-gfast-init-co
