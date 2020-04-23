set file_name "/home/wenjun/ns-allinone-2.35/ns-2.35/test/jiaoben.ti";
#set file_name "uniform.ti";

Class Flow

# the meaning of parameters
#t:	task id
#f:	flow id
#n:	node id   choose any node to send the flow
#s:	flow size
#a:	arrival time
Flow instproc init { t f n r s a} {

	$self instvar tid_;
	$self instvar fid_;
	$self instvar nid_;
	$self instvar rid__;       
	$self instvar flow_size_;
	$self instvar arrival_time_;

	set tid_ $t;
	set fid_ $f;
	set nid_ $n;
	set rid_ $r;
	set flow_size_ $s;
	set arrival_time_ $a;
}

Flow instproc getTid {} {

	$self instvar tid_;
	return $tid_;
}

Flow instproc getFid {} {

	$self instvar fid_;
	return $fid_;
}

Flow instproc getNid {} {

	$self instvar nid_;
	return $nid_;
}

Flow instproc getRid {} {

	$self instvar rid_;
	return $rid_;
}

Flow instproc getFS {} {

	$self instvar flow_size_;
	return $flow_size_;
}

Flow instproc getAT {} {

	$self instvar arrival_time_;
	return $arrival_time_;
}


proc ReadFile_ALL { file_name } {

	global flows;
	set f [open $file_name r];
	set cc 0;

	while { [gets $f line] != -1} {
	
		# puts "----$cc finished----";	
		set result [split $line];
		set flows($cc) [new Flow [lindex $result 0] [lindex $result 1] [lindex $result 2] [lindex $result 3] [lindex $result 4] [lindex $result 5]];
		set cc [expr $cc+1];
	}

	#puts ".ti file load finished..."
	close $f;
}


ReadFile_ALL $file_name;

