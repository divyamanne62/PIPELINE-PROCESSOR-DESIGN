

# 4-Stage Pipelined Processor

## Instructions Supported
- ADD
- SUB
- LOAD

## Pipeline Stages
1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Write Back (WB)

## Tools Required
- VS Code
- Icarus Verilog
- GTKWave

## Compile
iverilog -o pipeline processor.v processor_tb.v

## Run
vvp pipeline

## View Waveform
gtkwave pipeline.

##wave form
<img width="1280" height="960" alt="image" src="https://github.com/user-attachments/assets/19f58ce6-dfdc-4191-87f4-75de6e1ca4ca" />
