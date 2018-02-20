<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
               xmlns:mets="http://www.loc.gov/METS/"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="struct" select="doc('http://uri.hab.de/ontology/diglib-struct.rdf')"/>

  <xsl:template match="node() | @*">
    <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
  </xsl:template>

  <xsl:template match="@TYPE[. = $struct//rdfs:Class/rdfs:label]">
    <xsl:attribute name="TYPE" select="substring-after($struct//rdfs:Class[rdfs:label = current()]/@rdf:about, '#')"/>
  </xsl:template>

</xsl:transform>
