if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vlog rtl/sign_extend.v
vlog tb/sign_extend_tb.v
vsim -voptargs=+acc work.sign_extend_tb
# add wave *
do waves/sign_extend_wave.do

run -all
#quit -sim