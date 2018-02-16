<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xpath-default-namespace="http://www.loc.gov/METS/"
               xmlns="http://www.loc.gov/METS/"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Normalisiert die von Kitodo.Production erzeugte METS-Datei -->

  <xsl:template match="node() | @*">
    <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
  </xsl:template>

  <xsl:template match="mets">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="metsHdr">
    <metsHdr CREATEDATE="{@CREATEDATE}" LASTMODDATE="{current-dateTime()}">
      <agent ROLE="CUSTODIAN" TYPE="ORGANIZATION">
        <name>Herzog August Bibliothek Wolfenbüttel</name>
      </agent>
    </metsHdr>
  </xsl:template>

</xsl:transform>
