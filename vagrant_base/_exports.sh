#!/bin/bash -e

export VM_COLD_BOX='ubuntu/jammy64'
export VM_WARM_BOX='ucs-base'
export VM_USERNAME='vagrant'
export VM_MEMORY='4096'
num_cpus=$(nproc --ignore=1)
if [[ $num_cpus -gt 0 ]]; then
    export VM_CPUS=$(($num_cpus > 4 ? 4 : $num_cpus))
else
    export VM_CPUS=1
fi
export VM_DISK_SIZE='60GB'
