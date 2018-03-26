<p:declare-step version="1.0" name="main"
                xmlns:d="http://dmaus.name/ns/xproc"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source" primary="true" sequence="false"/>

  <p:option name="objectId"  required="true"/>
  <p:option name="targetUri" required="true"/>

  <p:import href="uuid.xpl"/>

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

  <p:documentation>Schritt 1: Validieren der von Kitodo.Production erzeugten METS-Datei</p:documentation>
  <p:validate-with-relax-ng name="validate-kitodo">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="schema">
      <p:data href="../schema/kitodo.rnc"/>
    </p:input>
  </p:validate-with-relax-ng>


  <p:documentation>Schritt 2: METS-Datei normalisieren</p:documentation>
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

  <p:documentation>Schritt 3: Normalisierte METS-Datei validieren</p:documentation>
  <p:validate-with-xml-schema assert-valid="true" name="validate-mets">
    <p:input port="source">
      <p:pipe step="normalize" port="result"/>
    </p:input>
    <p:input port="schema">
      <p:document href="../schema/mets.xsd"/>
    </p:input>
  </p:validate-with-xml-schema>

  <p:validate-with-schematron assert-valid="true">
    <p:input port="source">
      <p:pipe step="validate-mets" port="result"/>
    </p:input>
    <p:input port="schema">
      <p:document href="../schema/diglib.sch"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:validate-with-schematron>

  <p:documentation>Schritt 4: Normalisierte METS-Datei schreiben</p:documentation>
  <p:store>
    <p:with-option name="href" select="$targetUri"/>
  </p:store>

</p:declare-step>
