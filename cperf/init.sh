#!/bin/bash
pkill -9 -f Pass; pkill -9 -f pass; sleep 5; ./db_drop.sh; sleep 5; ./start.sh
