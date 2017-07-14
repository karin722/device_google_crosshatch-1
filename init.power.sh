#! /vendor/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

################################################################################

# Enable bus-dcvs
for cpubw in /sys/class/devfreq/*qcom,cpubw*
do
    write $cpubw/governor "bw_hwmon"
    write $cpubw/polling_interval 50
    write $cpubw/min_freq 1525
    write $cpubw/bw_hwmon/mbps_zones "3143 5859 11863 13763"
    write $cpubw/bw_hwmon/sample_ms 4
    write $cpubw/bw_hwmon/io_percent 34
    write $cpubw/bw_hwmon/hist_memory 20
    write $cpubw/bw_hwmon/hyst_length 10
    write $cpubw/bw_hwmon/low_power_ceil_mbps 0
    write $cpubw/bw_hwmon/low_power_io_percent 34
    write $cpubw/bw_hwmon/low_power_delay 20
    write $cpubw/bw_hwmon/guard_band_mbps 0
    write $cpubw/bw_hwmon/up_scale 250
    write $cpubw/bw_hwmon/idle_mbps 1600
done

write /sys/class/devfreq/soc:qcom,mincpubw/governor "cpufreq"

# Enable memlat governor
for memlat in /sys/class/devfreq/*qcom,memlat-cpu*
do
    write $memlat/governor "mem_latency"
    write $memlat/polling_interval 10
    write $memlat/mem_latency/ratio_ceil 400
done

# Signal perfd that boot has completed
setprop sys.post_boot.parsed 1
