module compare(input A,
               input B,
               input en,
               output logic AltB,
               output logic AbtB,
               output logic AeqB
               );

always_comb
begin
    if (~en)
    begin
        AltB = 1'b0;
        AbtB = 1'b0;
        AeqB = 1'b0;
    end
    else
    begin
        AltB = ~A & B;
        AbtB = A & ~B;
        AeqB = ~(A | A);
    end
end
endmodule        
        