import CAPI::*;

module parity_afu (
  input clock,
  output timebase_request,
  output parity_enabled,
  input JobInterfaceInput job_in,
  output JobInterfaceOutput job_out,
  input CommandInterfaceInput command_in,
  output CommandInterfaceOutput command_out,
  input BufferInterfaceInput buffer_in,
  output BufferInterfaceOutput buffer_out,
  input ResponseInterface response,
  input MMIOInterfaceInput mmio_in,
  output MMIOInterfaceOutput mmio_out);

  logic jdone;

  shift_register jdone_shift(
    .clock(clock),
    .in(jdone),
    .out(job_out.done));

  mmio mmio_handler(
    .clock(clock),
    .mmio_in(mmio_in),
    .mmio_out(mmio_out));

  assign job_out.running = 0,
         job_out.cack = 0,
         job_out.error = 0,
         job_out.yield = 0,
         timebase_request = 0,
         parity_enabled = 0;

  always_ff @(posedge clock) begin
    if(job_in.valid & job_in.command == RESET) begin
      jdone <= 1;
    end else begin
      jdone <= 0;
    end
  end

endmodule
