# p4app-INA

This repository contains p4 code to run in-network aggregation.

## Getting started

1. Compile the P4 code
2. Start the P4 program on the Tofino
3. Configure the Tofino ports, see bfrt/port.bfsh
4. Configure the table entries, see bfrt/setup.py

## Roadmap

|Status | Priority | Target | Type | Due |
| ------| ------ | ------ | ------ | ------ |
| **FIXED** | P1 | Fix the bug of wrong aggregation results | Tofino P4 | 2022.07.04|
| TODO | P2 | Implementing basic forwarding functions | Tofino P4 | |
| TODO | P3 | Enable fault tolerance | Tofino P4| |
| TODO | P3 | Integrate simulation with ns-3 | BMv2 P4 | 
