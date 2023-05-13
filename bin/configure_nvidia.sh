#!/bin/bash -e

# NOTE: THIS IS INCOMPLETE

# TODO: Adjust PowerMizer for each graphics card from 'Auto' to 'Prefer Maximum Performance'
# TODO: Configure monitor resolutions, refresh rates, and enable 'Allow G-SYNC on monitor not validated as G-Sync Compatible'
# TODO: https://askubuntu.com/questions/1407962/unable-to-install-cuda-on-ubuntu-22-04-wsl2
# BROKEN UNTIL THE ABOVE IS FIXED

# "X Server Display Configuration" is missing from nvidia-settings
# Change preference to nvidia to change this
sudo prime-select nvidia
# nvidia-settings -q all | grep -C 10 -i powermizer
#   Attribute 'GPUCurrentPerfLevel' (rastating-PC:1[gpu:0]): 3.
#     'GPUCurrentPerfLevel' is an integer attribute.
#     'GPUCurrentPerfLevel' is a read-only attribute.
#     'GPUCurrentPerfLevel' can use the following target types: X Screen, GPU.
# 
#   Attribute 'GPUAdaptiveClockState' (rastating-PC:1[gpu:0]): 1.
#     'GPUAdaptiveClockState' is a boolean attribute; valid values are: 1 (on/true) and 0 (off/false).
#     'GPUAdaptiveClockState' is a read-only attribute.
#     'GPUAdaptiveClockState' can use the following target types: X Screen, GPU.
# 
#   Attribute 'GPUPowerMizerMode' (rastating-PC:1[gpu:0]): 0.
#     Valid values for 'GPUPowerMizerMode' are: 0, 1 and 2.
#     'GPUPowerMizerMode' can use the following target types: GPU.
# 
#   Attribute 'GPUPowerMizerDefaultMode' (rastating-PC:1[gpu:0]): 0.
#     'GPUPowerMizerDefaultMode' is an integer attribute.
#     'GPUPowerMizerDefaultMode' is a read-only attribute.
#     'GPUPowerMizerDefaultMode' can use the following target types: GPU.
# 
#   Attribute 'ECCSupported' (rastating-PC:1[gpu:0]): 0.
#     'ECCSupported' is a boolean attribute; valid values are: 1 (on/true) and 0 (off/false).
#     'ECCSupported' is a read-only attribute.
#     'ECCSupported' can use the following target types: GPU.
# 
#   Attribute 'GPULogoBrightness' (rastating-PC:1[gpu:0]): 100.
#     The valid values for 'GPULogoBrightness' are in the range 0 - 100 (inclusive).
#     'GPULogoBrightness' can use the following target types: GPU.

nvidia-settings -a GpuPowerMizerMode=1
