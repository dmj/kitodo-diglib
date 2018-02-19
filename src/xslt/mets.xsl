<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xpath-default-namespace="http://www.loc.gov/METS/"
               xmlns="http://www.loc.gov/METS/"
               xmlns:fun="tag:maus@hab.de,2018-02:XSLT"
               xmlns:mods="http://www.loc.gov/mods/v3"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Normalisiert die von Kitodo.Production erzeugte METS-Datei -->
  <xsl:param name="objectId" as="xs:string" required="yes"/>
  <xsl:param name="eventCreateUUID" as="xs:string" required="yes"/>

  <xsl:key name="files" match="file" use="@ID"/>

  <xsl:template match="node() | @*">
    <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
  </xsl:template>

  <xsl:template match="mets">
    <mets OBJID="{$objectId}">
      <xsl:apply-templates/>
    </mets>
  </xsl:template>

  <xsl:template match="amdSec">
    <amdSec>
      <digiprovMD ID="id.{$eventCreateUUID}" CREATED="{current-dateTime()}">
        <mdWrap MDTYPE="PREMIS:EVENT">
          <xmlData>
            <premis:event xmlns:premis="http://www.loc.gov/premis/v3">
              <premis:eventIdentifier>
                <premis:eventIdentifierType>UUID</premis:eventIdentifierType>
                <premis:eventIdentifierValue><xsl:value-of select="$eventCreateUUID"/></premis:eventIdentifierValue>
              </premis:eventIdentifier>
              <premis:eventType valueURI="http://id.loc.gov/vocabulary/preservation/eventType/creation">creation</premis:eventType>
              <premis:eventDataTime><xsl:value-of select="/mets/metsHdr/@CREATEDATE"/></premis:eventDataTime>
              <premis:linkingAgentIdentifier>
                <premis:linkingAgentIdentifierType>Name</premis:linkingAgentIdentifierType>
                <premis:linkingAgentIdentifierValue><xsl:value-of select="/mets/metsHdr/agent/name"/></premis:linkingAgentIdentifierValue>
                <premis:linkingAgentRole valueURI="http://id.loc.gov/vocabulary/preservation/eventRelatedAgentRole/exe">executing program</premis:linkingAgentRole>
              </premis:linkingAgentIdentifier>
            </premis:event>
          </xmlData>
        </mdWrap>
      </digiprovMD>
    </amdSec>
  </xsl:template>

  <xsl:template match="@ADMID"/>

  <xsl:template match="dmdSec/mdWrap[@MDTYPE = 'MODS']/xmlData/mods:mods">
    <rdf:Description>
      <xsl:apply-templates/>
    </rdf:Description>
  </xsl:template>

  <xsl:template match="metsHdr">
    <metsHdr CREATEDATE="{@CREATEDATE}" LASTMODDATE="{current-dateTime()}" ADMID="id.{$eventCreateUUID}">
      <agent ROLE="CUSTODIAN" TYPE="ORGANIZATION">
        <name>Herzog August Bibliothek Wolfenbüttel</name>
      </agent>
    </metsHdr>
  </xsl:template>

  <xsl:template match="@ID[parent::file]">
    <xsl:attribute name="ID" select="fun:normalize-fileId(..)"/>
  </xsl:template>

  <xsl:template match="@FILEID">
    <xsl:attribute name="FILEID" select="fun:normalize-fileId(key('files', .))"/>
  </xsl:template>

  <xsl:template match="@xlink:href[ancestor::file/@MIMETYPE = 'image/jpeg']">
    <xsl:attribute name="xlink:href" select="concat('../', tokenize(., '/')[last()])"/>
  </xsl:template>

  <xsl:function name="fun:normalize-fileId" as="xs:string">
    <xsl:param name="file" as="element(file)"/>
    <xsl:value-of select="string-join( ('image', if ($file/../@USE) then lower-case($file/../@USE) else (), tokenize($file/FLocat/@xlink:href, '/')[last()]), '.')"/>
  </xsl:function>

</xsl:transform>
