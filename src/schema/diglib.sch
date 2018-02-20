<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="mets" uri="http://www.loc.gov/METS/"/>
  <ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
  <ns prefix="rdfs" uri="http://www.w3.org/2000/01/rdf-schema#"/>
  <pattern>
    <title>Strukturdatentypologie</title>
    <rule context="mets:div[@TYPE]">
      <assert test="concat('http://uri.hab.de/ontology/diglib-struct#', @TYPE) = doc('http://uri.hab.de/ontology/diglib-struct.rdf')//rdfs:Class/@rdf:about" id="structmap.unknown-type">
        Das @TYPE-Attribut einer Struktur muss mit einem in der Strukturdatentypologie definierten Wert belegt
        werden. Der Wert <value-of select="@TYPE"/> ist unbekannt.
      </assert>
    </rule>
  </pattern>
</schema>
