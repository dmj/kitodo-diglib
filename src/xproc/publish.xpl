<p:declare-step version="1.0" name="main"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source" primary="true" sequence="false"/>
  <p:output port="result" primary="true" sequence="false"/>

  <p:xslt name="normalize">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xslt/mets.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

  <p:validate-with-xml-schema assert-valid="true">
    <p:input port="source">
      <p:pipe step="normalize" port="result"/>
    </p:input>
    <p:input port="schema">
      <p:document href="../schema/mets.xsd"/>
    </p:input>
  </p:validate-with-xml-schema>

</p:declare-step>
