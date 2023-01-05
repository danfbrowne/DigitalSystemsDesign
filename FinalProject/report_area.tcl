#Daniel Browne EECE 573
#Provides Primatives of the utilization report for each state encoding
proc report_area { index } {
    #List of state encodings
    set en(0) "off"
    set en(1) "one_hot"
    set en(2) "sequential"
    set en(3) "johnson"
    set en(4) "gray"
    set en(5) "auto"
    if {$index == 0} {
    	set fp [open area.rpt "w"]
    	puts $fp "# Daniel Browne EECE 573"
	set systemTime [clock seconds]
        puts $fp "# File created on [clock format $systemTime -format {%a %b %d %T %Z %Y}]"
    } else {
        set fp [open area.rpt "a"]
    }
    puts $fp "# Showing Area Report For $en($index)"
    set r [report_utilization -return_string]
    puts %r
    set lines [split $r "\n"]
    set count 0
    set goal 1
    set in 0
    foreach line $lines {
    	if {[string is integer -strict [string index $line 0]]} {
            if {[string first " " $line] == 2} {
                if {[string first "8" $line] == 0} {
                    incr count
                    if {$count > $goal} {
                        set in 1
                    } 
                } else {
                    set in 0
                }
            } else {
                set in 0
            }
        }
        if {$in} {
            puts $fp $line
        }
    }
    close $fp
    puts "Area report area.rpt successfully created."
}