part of sqljocky;

class _PingHandler extends _Handler {
  _PingHandler() {
    log = new Logger("PingHandler");
  }
  
  Buffer createRequest() {
    var buffer = new Buffer(1);
    buffer.writeByte(COM_PING);
    return buffer;
  }
}
