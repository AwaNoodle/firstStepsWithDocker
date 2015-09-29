#!/bin/bash

value="$(shuf -i 0-100 -n 1)"
echo "Sending data to cpu_load_short with value $value"
curl -i -XPOST 'http://localhost:8086/write?db=db1' --data-binary "cpu_load_short,host=server01,region=us-west value=$value"