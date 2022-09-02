#!/bin/bash -xe

echo $( lsb_release -c | sed -E 's|Codename:\s+([^\s]+)|\1|' )
