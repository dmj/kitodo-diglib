<!-- Konvertiert eine facsimile.xml in das neue METS Internformat -->
<!-- Autor: David Maus <maus@hab.de>                              -->
<!-- Timestamp: <2018-03-26 11:38:57 maus>                        -->
<xsl:transform version="2.0"
               xmlns="http://www.loc.gov/METS/"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:premis="http://www.loc.gov/premis/v3"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:tei="http://www.tei-c.org/ns/1.0"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="objectId" as="xs:string" required="yes"/>
  <xsl:param name="eventCreateUUID" as="xs:string" required="yes"/>
  <xsl:param name="eventCreateAgent" as="xs:string" required="yes"/>
  <xsl:param name="structMapLogicalType" as="xs:string">Monograph</xsl:param>

  <xsl:template match="tei:facsimile">
    <mets OBJID="{$objectId}">
      <metsHdr CREATEDATE="{current-dateTime()}" LASTMODDATE="{current-dateTime()}">
        <agent ROLE="CUSTODIAN" TYPE="ORGANIZATION">
          <name>Herzog August Bibliothek Wolfenbüttel</name>
        </agent>
      </metsHdr>
      <dmdSec ID="de.hab.diglib-mets-dmd-primary">
        <mdWrap MDTYPE="OTHER" OTHERMDTYPE="RDF" MIMETYPE="application/rdf+xml">
          <xmlData>
            <include href="about.rdf">
              <fallback>
                <rdf:Description>
                  <dct:bibliographicCitation>Unbekanntes Objekt / Unknown object</dct:bibliographicCitation>
                </rdf:Description>
              </fallback>
            </include>
          </xmlData>
        </mdWrap>
      </dmdSec>
      <amdSec>
        <digiprovID ID="id.{$eventCreateUUID}" CREATED="{current-dateTime()}">
          <mdWrap MDTYPE="PREMIS:EVENT">
            <xmlData>
              <premis:event>
                <premis:eventIdentifier>
                  <premis:eventIdentifierType>UUID</premis:eventIdentifierType>
                  <premis:eventIdentifierValue><xsl:value-of select="$eventCreateUUID"/></premis:eventIdentifierValue>
                </premis:eventIdentifier>
                <premis:eventType valueURI="http://id.loc.gov/vocabulary/preservation/eventType/cre">creation</premis:eventType>
                <premis:eventDataTime><xsl:value-of select="current-dateTime()"/></premis:eventDataTime>
                <premis:linkingAgentIdentifier>
                  <premis:linkingAgentIdentifierType>Name</premis:linkingAgentIdentifierType>
                  <premis:linkingAgentIdentifierValue><xsl:value-of select="$eventCreateAgent"/></premis:linkingAgentIdentifierValue>
                  <premis:linkingAgentRole valueURI="http://id.loc.gov/vocabulary/preservation/eventRelatedAgentRole/exe">executing program</premis:linkingAgentRole>
                </premis:linkingAgentIdentifier>
              </premis:event>
            </xmlData>
          </mdWrap>
        </digiprovID>
      </amdSec>
      <fileSec>
        <fileGrp USE="DEFAULT">
          <xsl:apply-templates mode="fileSec"/>
        </fileGrp>
      </fileSec>
      <structMap TYPE="LOGICAL">
        <div TYPE="{$structMapLogicalType}" ID="LOG_0000"/>
      </structMap>
      <structMap TYPE="PHYSICAL">
        <div TYPE="physSequence">
          <xsl:apply-templates mode="structMap"/>
        </div>
      </structMap>
      <structLink>
        <xsl:apply-templates mode="structLink"/>
      </structLink>
    </mets>
  </xsl:template>

  <xsl:template match="tei:graphic" mode="fileSec">
    <file ID="de.hab.diglib-mets-file.default.{tokenize(@xml:id, '_')[last()]}" MIMETYPE="image/jpeg">
      <FLocat LOCTYPE="URL" xlink:href="../{tokenize(@url, '/')[last()]}"/>
    </file>
  </xsl:template>

  <xsl:template match="tei:graphic" mode="structMap">
    <div ID="de.hab.diglib-mets-phys.{tokenize(@xml:id, '_')[last()]}" ORDER="{position()}" TYPE="page">
      <xsl:if test="@n"><xsl:attribute name="ORDERLABEL" select="@n"/></xsl:if>
      <fptr FILEID="de.hab.diglib-mets-file.default.{tokenize(@xml:id, '_')[last()]}"/>
    </div>
  </xsl:template>

  <xsl:template match="tei:graphic" mode="structLink">
    <smLink xlink:to="de.hab.diglib-mets-phys.{tokenize(@xml:id, '_')[last()]}" xlink:from="LOG_0000"/>
  </xsl:template>

  <xsl:template match="text()" mode="#all"/>

</xsl:transform>
