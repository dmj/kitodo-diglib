<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xpath-default-namespace="http://www.loc.gov/METS/"
               xmlns="http://www.loc.gov/METS/"
               xmlns:fun="tag:maus@hab.de,2018-02:XSLT"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Normalisiert die von Kitodo.Production erzeugte METS-Datei -->
  <xsl:param name="objectId" as="xs:string" required="yes"/>

  <xsl:key name="files" match="file" use="@ID"/>

  <xsl:template match="node() | @*">
    <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
  </xsl:template>

  <xsl:template match="mets">
    <mets OBJID="{$objectId}">
      <xsl:apply-templates/>
    </mets>
  </xsl:template>

  <xsl:template match="metsHdr">
    <metsHdr CREATEDATE="{@CREATEDATE}" LASTMODDATE="{current-dateTime()}">
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
