<p:declare-step version="1.0" name="main"
                xmlns:d="http://dmaus.name/ns/xproc"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source" primary="true" sequence="false"/>
  <p:output port="result" primary="true" sequence="false"/>

  <p:option name="objectId"  required="true"/>
  <p:option name="targetUri" required="false"/>

  <p:import href="uuid.xpl"/>

  <d:uuid-event name="uuid-source">
    <p:input port="source">
      <p:inline>
        <uuid/>
      </p:inline>
    </p:input>
    <p:with-option name="event" select="'create'"/>
  </d:uuid-event>

  <p:xslt name="facs2mets">
    <p:with-param name="objectId" select="$objectId"/>
    <p:with-param name="eventCreateUUID" select="/uuid/@create">
      <p:pipe step="uuid-source" port="result"/>
    </p:with-param>
    <p:with-param name="eventCreateAgent" select="concat(p:system-property('p:product-name'), ' ', p:system-property('p:product-version'))"/>
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xslt/facs2mets.xsl"/>
    </p:input>
  </p:xslt>

</p:declare-step>
