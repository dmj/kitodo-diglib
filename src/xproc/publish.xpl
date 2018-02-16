<p:declare-step version="1.0" name="main"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source" primary="true" sequence="false"/>
  <p:output port="result" primary="true" sequence="false"/>

  <p:option name="objectId" required="true"/>

  <p:serialization port="result" indent="true"/>

  <p:validate-with-schematron name="validate-kitodo">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="schema">
      <p:document href="../schema/kitodo.sch"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:validate-with-schematron>

  <p:xslt name="normalize">
    <p:with-param name="objectId" select="$objectId"/>
    <p:input port="source">
      <p:pipe step="validate-kitodo" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xslt/mets.xsl"/>
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
