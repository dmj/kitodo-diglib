<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns uri="http://www.loc.gov/METS/" prefix="mets"/>
  <pattern>
    <rule context="mets:mets">
      <assert test="count(mets:fileSec/mets:fileGrp) eq 1 and mets:fileSec/mets:fileGrp/@USE = 'DEFAULT'">
        Die von Kitodo.Production erstellte METS-Datei muss genau eine fileGrp USE=DEFAULT enthalten.
      </assert>
    </rule>
  </pattern>
</schema>
