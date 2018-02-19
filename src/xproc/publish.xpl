<p:declare-step version="1.0" name="main"
                xmlns:d="http://dmaus.name/ns/xproc"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source" primary="true" sequence="false"/>

  <p:option name="objectId"  required="true"/>
  <p:option name="targetUri" required="true"/>

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

  <p:declare-step type="d:uuid-source">
    <p:output port="result"/>
    <p:identity>
      <p:input port="source">
        <p:inline>
          <uuid/>
        </p:inline>
      </p:input>
    </p:identity>
    <d:uuid-event event="create"/>
    <d:uuid-event event="normalize"/>
  </p:declare-step>

  <d:uuid-source name="uuid-source"/>

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
        <p:with-param name="eventNormalizeUUID" select="/uuid/@normalize">
          <p:pipe step="uuid-source" port="result"/>
        </p:with-param>
        <p:with-param name="eventNormalizeAgent" select="concat(p:system-property('p:product-name'), ' ', p:system-property('p:product-version'))"/>
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
