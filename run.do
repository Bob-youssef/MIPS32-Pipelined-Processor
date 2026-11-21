if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vlog rtl/register_file.v
vlog tb/register_file_tb.v
vsim -voptargs=+acc work.register_file_tb
# add wave *
do waves/register_file_wave.do

run -all
#quit -sim