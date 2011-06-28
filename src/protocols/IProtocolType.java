package protocols;

import gw.lang.parser.ISourceCodeTokenizer;
import gw.lang.reflect.IType;

public interface IProtocolType extends IType {

  public IProtocolType getInnerProtocol( Integer i );

  boolean isAnonymous();

  void setTypeInfo(ProtocolTypeInfo innerTypeInfo);

  IProtocolType getNextInnerProtocol(ISourceCodeTokenizer tokenizer);

  void addError(ProtocolError protocolError);

  Object getSource();

  void verify();
}