//Daniel Browne
//EECE 573 Final Project
//Round-robin arbiter for two devices using a shared resource

`define SWIDTH 3

module arbiter2( 
	input clk, reset, ra, rb,
	output Ga, Gb);

assign Ga = (~state[2] && state[1]);
assign Gb = (state[2] && state[1]);

localparam [`SWIDTH-1:0] 
	A Priority=`SWIDTH'h0,  //00 000
	A Hold=`SWIDTH'h2,      //10 010
	A Using=`SWIDTH'h3,     //10 011
	B Priority=`SWIDTH'h4,  //00 100
	B Hold=`SWIDTH'h6,      //01 110
	B Using=`SWIDTH'h7;     //01 111

reg [`SWIDTH-1:0] state, next_state;

always @( posedge clk) begin
	if ( reset == 1'b1 )
		state <= A Priority;
	else
		state <= next_state;
end

always @(*) begin
    case(state)
		A Priority: if( ra )
				next_state=A Hold;
			else if( rb )
				next_state=B Using;
            else
                next_state=A Priority;
		A Hold: if( ra )
				next_state=A Hold;
			else if ( rb )
				next_state=B Using;
            else
                next_state=B Priority;
		A Using: if( rb )
				next_state=B Hold;
			else if ( ra )
				next_state=A Using;
			else
				next_state=B Priority;
		B Priority:	if( rb )
				next_state=B Hold;
			else if ( ra )
				next_state=A Using;
            else
                next_state=B Priority;
		B Hold:	if( rb )
				next_state=B Hold;
			else if ( ra )
				next_state=A Using;
            else
                next_state=A Priority;
		B Using:	if( ra )
				next_state=A Hold;
			else if ( rb )
				next_state=B Using;
			else
				next_state=A Priority;
		default:
			next_state=`SWIDTH'bxxx;
	endcase
end
endmodule
