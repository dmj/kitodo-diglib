<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xpath-default-namespace="http://www.loc.gov/METS/"
               xmlns="http://www.loc.gov/METS/"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:fun="tag:maus@hab.de,2018-02:XSLT"
               xmlns:mods="http://www.loc.gov/mods/v3"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Normalisiert die von Kitodo.Production erzeugte METS-Datei -->
  <xsl:param name="objectId" as="xs:string" required="yes"/>
  <xsl:param name="eventCreateUUID" as="xs:string" required="yes"/>
  <xsl:param name="eventNormalizeUUID" as="xs:string" required="yes"/>
  <xsl:param name="eventNormalizeAgent" as="xs:string" required="yes"/>

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
    <dmdSec ID="de.hab.diglib-mets-dmd-primary">
      <mdWrap MDTYPE="OTHER" OTHERMDTYPE="RDF" MIMETYPE="application/rdf+xml">
        <xmlData>
          <xsl:element name="include" namespace="http://www.w3.org/2001/XInclude">
            <xsl:attribute name="href">about.rdf</xsl:attribute>
            <xsl:element name="fallback" namespace="http://www.w3.org/2001/XInclude">
              <rdf:Description>
                <dct:bibliographicCitation>Unbekanntes Objekt / Unknown object</dct:bibliographicCitation>
              </rdf:Description>
            </xsl:element>
          </xsl:element>
        </xmlData>
      </mdWrap>
    </dmdSec>
    <amdSec>
      <digiprovMD ID="id.{$eventCreateUUID}" CREATED="{current-dateTime()}">
        <mdWrap MDTYPE="PREMIS:EVENT">
          <xmlData>
            <premis:event xmlns:premis="http://www.loc.gov/premis/v3">
              <premis:eventIdentifier>
                <premis:eventIdentifierType>UUID</premis:eventIdentifierType>
                <premis:eventIdentifierValue><xsl:value-of select="$eventCreateUUID"/></premis:eventIdentifierValue>
              </premis:eventIdentifier>
              <premis:eventType valueURI="http://id.loc.gov/vocabulary/preservation/eventType/cre">creation</premis:eventType>
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
      <digiprovMD ID="id.{$eventNormalizeUUID}" CREATED="{current-dateTime()}">
        <mdWrap MDTYPE="PREMIS:EVENT">
          <xmlData>
            <premis:event xmlns:premis="http://www.loc.gov/premis/v3">
              <premis:eventIdentifier>
                <premis:eventIdentifierType>UUID</premis:eventIdentifierType>
                <premis:eventIdentifierValue><xsl:value-of select="$eventNormalizeUUID"/></premis:eventIdentifierValue>
              </premis:eventIdentifier>
              <premis:eventType valueURI="http://id.loc.gov/vocabulary/preservation/eventType/nor">normalization</premis:eventType>
              <premis:eventDataTime><xsl:value-of select="current-dateTime()"/></premis:eventDataTime>
              <premis:linkingAgentIdentifier>
                <premis:linkingAgentIdentifierType>Name</premis:linkingAgentIdentifierType>
                <premis:linkingAgentIdentifierValue><xsl:value-of select="$eventNormalizeAgent"/></premis:linkingAgentIdentifierValue>
                <premis:linkingAgentRole valueURI="http://id.loc.gov/vocabulary/preservation/eventRelatedAgentRole/exe">executing program</premis:linkingAgentRole>
              </premis:linkingAgentIdentifier>
            </premis:event>
          </xmlData>
        </mdWrap>
      </digiprovMD>
    </amdSec>
  </xsl:template>

  <xsl:template match="@ADMID"/>

  <xsl:template match="dmdSec/mdWrap[@MDTYPE = 'MODS']">
    <mdWrap MDTYPE="OTHER" OTHERMDTYPE="RDF" MIMETYPE="application/rdf+xml">
      <xsl:apply-templates/>
    </mdWrap>
  </xsl:template>

  <xsl:template match="dmdSec/mdWrap[@MDTYPE = 'MODS']/xmlData/mods:mods">
    <rdf:Description>
      <xsl:apply-templates/>
    </rdf:Description>
  </xsl:template>

  <xsl:template match="metsHdr">
    <metsHdr CREATEDATE="{@CREATEDATE}" LASTMODDATE="{current-dateTime()}" ADMID="id.{$eventCreateUUID} id.{$eventNormalizeUUID}">
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

  <xsl:function name="fun:normalize-physId" as="xs:string">
    <xsl:param name="fileId" as="xs:string"/>
    <xsl:value-of>
      <xsl:text>de.hab.diglib-mets-phys.</xsl:text>
      <xsl:value-of select="tokenize($fileId, '\.')[last()]"/>
    </xsl:value-of>
  </xsl:function>

  <xsl:function name="fun:normalize-fileId" as="xs:string">
    <xsl:param name="file" as="element(file)"/>
    <xsl:value-of>
      <xsl:text>de.hab.diglib-mets-file</xsl:text>
      <xsl:if test="$file/../@USE">
        <xsl:value-of select="concat('.', lower-case($file/../@USE))"/>
      </xsl:if>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="substring-before(tokenize($file/FLocat/@xlink:href, '/')[last()], '.')"/>
    </xsl:value-of>
  </xsl:function>

</xsl:transform>
