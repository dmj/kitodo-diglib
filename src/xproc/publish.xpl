<p:declare-step version="1.0" name="main"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source" primary="true" sequence="false"/>

  <p:option name="objectId"  required="true"/>
  <p:option name="targetUri" required="true"/>

  <p:uuid name="uuid-source" version="4" match="@create">
    <p:input port="source">
      <p:inline>
        <uuid create=""/>
      </p:inline>
    </p:input>
  </p:uuid>

  <p:choose>
    <p:when test="doc-available(resolve-uri($targetUri))">
      <p:error code="TargetFileExists">
        <p:input port="source">
          <p:empty/>
        </p:input>
      </p:error>
      <p:sink/>
    </p:when>
    <p:otherwise>

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
        <p:with-param name="eventCreateUUID" select="/uuid/@create">
          <p:pipe step="uuid-source" port="result"/>
        </p:with-param>
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

      <p:store>
        <p:with-option name="href" select="$targetUri"/>
      </p:store>

    </p:otherwise>

  </p:choose>

</p:declare-step>
