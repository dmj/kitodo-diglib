<p:library version="1.0"
           xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:d="http://dmaus.name/ns/xproc">

  <p:declare-step type="d:uuid-event">
    <p:input  port="source"/>
    <p:output port="result"/>
    <p:option name="event" required="true"/>

    <p:add-attribute attribute-value="" match="uuid">
      <p:with-option name="attribute-name" select="$event"/>
    </p:add-attribute>
    <p:uuid version="4">
      <p:with-option name="match" select="concat('@', $event)"/>
    </p:uuid>
  </p:declare-step>

</p:library>
