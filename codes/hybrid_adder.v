module full_adder(
  input a, b, cin,
  output sum, cout
);
  
  assign {sum, cout} = {a^b^cin, ((a & b) | (b & cin) | (a & cin))};
  //or
  //assign sum = a^b^cin;
  //assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module ripple_carry_adder #(parameter SIZE = 1) (
  input [SIZE-1:0] A, B, 
  input Cin,
  output [SIZE-1:0] S,
  output Cout);
  wire [SIZE-2:0] carry;
  genvar g;
  
  full_adder fa0(A[0], B[0], Cin, S[0], carry[0]);
  generate  // This will instantiate full_adder SIZE-1 times
    for(g = 1; g<SIZE-1; g=g+1) begin
      full_adder fa(A[g], B[g], carry[g-1], S[g], carry[g]);
    end
      full_adder fa(A[SIZE-1], B[SIZE-1], carry[SIZE-2], S[SIZE-1], Cout);
  endgenerate
endmodule


module reverse_adder(
  input a, b, c2,f1,
  output sum,f2,c1
);
wire x,y;

assign x=~((a&b)|(~c2));
assign y=~((a|b)&(~c2));
assign sum=~(((~f1)|x)&(y));
assign c1=~((f1&y)|(x));
assign f2=a;
endmodule

//module reverse_adder(
//  input a, b, c2,f1,
//  output sum,f2,c1
//);
//wire y;

//assign y=~((a|b)&(~c2));
//assign sum=~(y&f1);
//assign c1=~(y&f1);
//assign f2=~(a&b);
//endmodule

//module reverse_adder(
//  input a, b, c2,f1,
//  output sum,f2,c1
//);
//wire x;

//assign x=~((a&b)|(~c2));
//assign sum=~(x|f1);
//assign c1=~(x|f1);
//assign f2=~(a|b);
//endmodule

//module reverse_adder(
//  input a, b, c2,f1,
//  output sum,f2,c1
//);
//wire x,y;

//assign x=~((a&b)|(~c2));
//assign y=~((a|b)&(~c2));
//assign sum=~(((~f1)|x)&(y));
//assign c1=f1;
//assign f2=a;
//endmodule

//module reverse_adder(
//  input a, b, c2,f1,
//  output sum,f2,c1
//);
//wire x,y;

//assign x=((a&b)|(~c2));
//assign y=f1;
//assign sum=(x&y);
//assign c1=f1;
//assign f2=a;
//endmodule


//module reverse_adder(
//  input a, b, c2,f1,
//  output sum,f2,c1
//);
//wire x,y;

//assign x=((a&b)|(~c2));
//assign y=f1;
//assign sum=(x&y);
//assign c1=f1;
//assign f2=~(a&b);
//endmodule


module reverse_carry_adder #(parameter SIZE = 7) (
  input [SIZE-1:0] A, B, 
  input C0,
  output [SIZE-1:0] sum,Fn);
  wire [SIZE-1:1]F;
  wire x;
  wire [SIZE-1:1] C;
  genvar g;
  reverse_adder ra1 (A[0],B[0],C[1],C0,sum[0],F[1],x);
  // reverse_adder_1 dabba2 (A[1],B[1],C[2],F[1],sum[1],F[2],C[1]);
  // reverse_adder_1 dabba3 (A[2],B[2],C[3],F[2],sum[2],F[3],C[2]);
  generate  // This will instantiate full_adder SIZE-1 times
    for(g = 1; g<SIZE-1; g=g+1) begin
      reverse_adder ra(A[g], B[g], C[g+1],F[g],sum[g],F[g+1],C[g]);
    end
  endgenerate
  reverse_adder ran (A[SIZE-1],B[SIZE-1],Fn,F[SIZE-1],sum[SIZE-1],Fn,C[SIZE-1]);

  
endmodule


module hybrid_adder #(parameter M = 1, parameter N = 7) (
  input [M+N-1:0] A, B, 
  input Cin,
  output [M+N:0] S,
  output Cout);
  wire Fn;
  
  reverse_carry_adder uut(A[M-1:0],B[M-1:0],Cin,S[M-1:0],Fn);
  ripple_carry_adder uut1(A[M+N-1:M],B[M+N-1:M],Fn,S[M+N-1:M],Cout);
  
  
 endmodule
