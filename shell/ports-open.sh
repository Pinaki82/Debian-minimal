#!/bin/bash

# The command below lists the number of open ports on the system.

ss -tuln | grep LISTEN \
