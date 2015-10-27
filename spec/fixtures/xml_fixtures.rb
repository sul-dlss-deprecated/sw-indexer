module XmlFixtures
  def item_image_mods
    <<-xml
    <mods xmlns="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.3" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd">
      <titleInfo>
        <title>Item title</title>
      </titleInfo>
      <name type="personal">
        <namePart>Personal name</namePart>
        <role>
          <roleTerm authority="marcrelator" type="text">Role</roleTerm>
        </role>
      </name>
      <typeOfResource>still image</typeOfResource>
      <originInfo>
        <dateCreated point="start" keyDate="yes">1909</dateCreated>
        <dateCreated point="end">1915</dateCreated>
      </originInfo>
      <relatedItem type="host">
        <titleInfo>
          <title>Collection Title</title>
        </titleInfo>
        <identifier type="uri">https://purl.stanford.edu/oo000oo0000</identifier>
        <typeOfResource collection="yes"/>
      </relatedItem>
      <accessCondition type="copyright">Access Condition</accessCondition>
    </mods>
    xml
  end

  def item_book_mods
    <<-xml
    <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.loc.gov/mods/v3" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
         <identifier type="local" displayLabel="Source ID">RBC_QA76.P396FF_5:3</identifier>
         <typeOfResource>text</typeOfResource>
         <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026652">newsletters</genre>
         <titleInfo>
             <title>People's Computer Company</title>
             <partNumber>5:3</partNumber>
         </titleInfo>
         <name type="corporate" authority="naf" valueURI="http://id.loc.gov/authorities/names/n77008526">
             <namePart>People's Computer Company</namePart>
             <role>
                 <roleTerm type="text" authority="marcrelator" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
             </role>
         </name>
         <originInfo>
             <dateIssued encoding="w3cdtf" keyDate="yes">1976-11</dateIssued>
             <issuance>continuing</issuance>
         </originInfo>
         <physicalDescription>
             <form authority="rdacarrier">volume</form>
             <extent>1 newsletter</extent>
             <digitalOrigin>reformatted digital</digitalOrigin>
             <internetMediaType>image/jpeg</internetMediaType>
             <internetMediaType>application/pdf</internetMediaType>
         </physicalDescription>
         <subject authority="lcsh" valueURI="http://id.loc.gov/authorities/subjects/sh2008101488">
             <topic>Computer industry--United States--History</topic>
         </subject>
         <subject authority="lcsh" valueURI="http://id.loc.gov/authorities/subjects/sh85084825">
             <topic>Microelectronics industry</topic>
         </subject>
         <subject authority="lcsh">
             <name type="corporate" authority="naf" valueURI="http://id.loc.gov/authorities/names/n77008526">
                 <namePart>People's Computer Company</namePart>
             </name>
         </subject>
         <language>
             <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
         </language>
         <recordInfo>
             <languageOfCataloging>
                 <languageTerm authority="iso639-2b">eng</languageTerm>
             </languageOfCataloging>
             <recordContentSource authority="marcorg">CSt</recordContentSource>
             <recordIdentifier>druid:cg160px5426</recordIdentifier>
         </recordInfo>
         <relatedItem type="host">
             <titleInfo>
                 <title>People's Computer Company</title>
             </titleInfo>
             <identifier type="uri">http://purl.stanford.edu/cj445qq4021</identifier>
             <typeOfResource collection="yes"/>
         </relatedItem>
         <accessCondition type="useAndReproduction">
             Property rights reside with the repository. Literary rights reside with the creators of the documents or their heirs. To obtain permission to publish or reproduce, please contact the Public Services Librarian of the Dept. of Special Collections (http://library.stanford.edu/spc).
         </accessCondition>
     </mods>
    xml
  end

  def item_image_xml
    <<-xml
    <publicObject id="druid:zz999zz9999" published="2015-02-26T14:10:51-08:00">
      <identityMetadata>
        <sourceId source="hoover">2012c34_3_a</sourceId>
        <objectId>druid:zz999zz9999</objectId>
        <objectCreator>DOR</objectCreator>
        <objectLabel>Item Title</objectLabel>
        <objectType>item</objectType>
        <adminPolicy>druid:aa111bb2222</adminPolicy>
        <otherId name="label"/>
        <otherId name="uuid">080ac28c-5159-11e3-815a-0050569b3c3c</otherId>
        <tag>Process : Content Type : Image</tag>
        <tag>Project : Collection</tag>
        <tag>Registered By : blalbrit</tag>
        <tag>Remediated By : 4.17.1</tag>
      </identityMetadata>
      <contentMetadata objectId="zz999zz9999" type="image">
        <resource id="zz999zz9999_1" sequence="1" type="image">
          <label>Image 1</label>
          <file id="a24.jp2" mimetype="image/jp2" size="3674159">
            <imageData width="5334" height="3660"/>
          </file>
        </resource>
        <resource id="zz999zz9999_2" sequence="2" type="image">
          <label>Image 2</label>
          <file id="a25.jp2" mimetype="image/jp2" size="3706126">
            <imageData width="5508" height="3576"/>
          </file>
        </resource>
        <resource id="zz999zz9999_3" sequence="3" type="image">
          <label>Image 3</label>
          <file id="a26.jp2" mimetype="image/jp2" size="2543862">
            <imageData width="3450" height="3918"/>
          </file>
        </resource>
        <resource id="zz999zz9999_4" sequence="4" type="image">
          <label>Image 4</label>
          <file id="a27.jp2" mimetype="image/jp2" size="3370403">
            <imageData width="4950" height="3618"/>
          </file>
        </resource>
        <resource id="zz999zz9999_5" sequence="5" type="image">
          <label>Image 5</label>
          <file id="a28.jp2" mimetype="image/jp2" size="3471135">
            <imageData width="4950" height="3726"/>
          </file>
        </resource>
      </contentMetadata>
      <rightsMetadata>
        <access type="discover">
          <machine>
            <world/>
          </machine>
        </access>
        <access type="read">
          <machine>
            <world/>
          </machine>
        </access>
        <use>
          <human type="useAndReproduction"/>
          <human type="creativeCommons"/>
          <machine type="creativeCommons"/>
        </use>
        <copyright>
          <human type="copyright">Copyright</human>
        </copyright>
      </rightsMetadata>
      <rdf:RDF xmlns:fedora="info:fedora/fedora-system:def/relations-external#" xmlns:fedora-model="info:fedora/fedora-system:def/model#" xmlns:hydra="http://projecthydra.org/ns/relations#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
        <rdf:Description rdf:about="info:fedora/druid:zz999zz9999">
          <fedora:isMemberOf rdf:resource="info:fedora/druid:oo000oo0000"/>
          <fedora:isMemberOfCollection rdf:resource="info:fedora/druid:oo000oo0000"/>
        </rdf:Description>
      </rdf:RDF>
      <oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:srw_dc="info:srw/schema/1/dc-schema" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
        <dc:title>DC title</dc:title>
        <dc:contributor>DC contributor</dc:contributor>
        <dc:type>StillImage</dc:type>
        <dc:date>1909-1915</dc:date>
        <dc:relation type="collection">DC relation Collection title</dc:relation>
      </oai_dc:dc>
      <ReleaseDigest/>
    </publicObject>
    xml
  end

  def item_file_xml
    <<-xml
    <publicObject id="druid:zz999zz9999" published="2015-02-26T14:10:51-08:00">
      <identityMetadata>
        <sourceId source="hoover">2012c34_3_a</sourceId>
        <objectId>druid:zz999zz9999</objectId>
        <objectCreator>DOR</objectCreator>
        <objectLabel>Item Title</objectLabel>
        <objectType>item</objectType>
        <adminPolicy>druid:aa111bb2222</adminPolicy>
        <otherId name="label"/>
        <otherId name="uuid">080ac28c-5159-11e3-815a-0050569b3c3c</otherId>
        <tag>Process : Content Type : Image</tag>
        <tag>Project : Collection</tag>
        <tag>Registered By : blalbrit</tag>
        <tag>Remediated By : 4.17.1</tag>
      </identityMetadata>
      <contentMetadata objectId="zz999zz9999" type="file">
        <resource id="zz999zz9999_1" sequence="1" type="image">
          <label>Image 1</label>
          <file id="a24.jp2" mimetype="image/jp2" size="3674159">
            <imageData width="5334" height="3660"/>
          </file>
        </resource>
        <resource id="zz999zz9999_2" sequence="2" type="image">
          <label>Image 2</label>
          <file id="a25.jp2" mimetype="image/jp2" size="3706126">
            <imageData width="5508" height="3576"/>
          </file>
        </resource>
        <resource id="zz999zz9999_3" sequence="3" type="image">
          <label>Image 3</label>
          <file id="a26.jp2" mimetype="image/jp2" size="2543862">
            <imageData width="3450" height="3918"/>
          </file>
        </resource>
        <resource id="zz999zz9999_4" sequence="4" type="image">
          <label>Image 4</label>
          <file id="a27.jp2" mimetype="image/jp2" size="3370403">
            <imageData width="4950" height="3618"/>
          </file>
        </resource>
        <resource id="zz999zz9999_5" sequence="5" type="image">
          <label>Image 5</label>
          <file id="a28.jp2" mimetype="image/jp2" size="3471135">
            <imageData width="4950" height="3726"/>
          </file>
        </resource>
      </contentMetadata>
      <rightsMetadata>
        <access type="discover">
          <machine>
            <world/>
          </machine>
        </access>
        <access type="read">
          <machine>
            <world/>
          </machine>
        </access>
        <use>
          <human type="useAndReproduction"/>
          <human type="creativeCommons"/>
          <machine type="creativeCommons"/>
        </use>
        <copyright>
          <human type="copyright">Copyright</human>
        </copyright>
      </rightsMetadata>
      <rdf:RDF xmlns:fedora="info:fedora/fedora-system:def/relations-external#" xmlns:fedora-model="info:fedora/fedora-system:def/model#" xmlns:hydra="http://projecthydra.org/ns/relations#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
        <rdf:Description rdf:about="info:fedora/druid:zz999zz9999">
          <fedora:isMemberOf rdf:resource="info:fedora/druid:oo000oo0000"/>
          <fedora:isMemberOfCollection rdf:resource="info:fedora/druid:oo000oo0000"/>
        </rdf:Description>
      </rdf:RDF>
      <oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:srw_dc="info:srw/schema/1/dc-schema" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
        <dc:title>DC title</dc:title>
        <dc:contributor>DC contributor</dc:contributor>
        <dc:type>StillImage</dc:type>
        <dc:date>1909-1915</dc:date>
        <dc:relation type="collection">DC relation Collection title</dc:relation>
      </oai_dc:dc>
      <ReleaseDigest/>
    </publicObject>
    xml
  end

  def item_book_xml
    <<-xml
    <publicObject id="druid:cg160px5426" published="2015-10-01T10:20:11-07:00">
       <identityMetadata>
         <objectId>druid:cg160px5426</objectId>
         <objectCreator>DOR</objectCreator>
         <objectLabel>People's Computer Company</objectLabel>
         <objectType>item</objectType>
         <adminPolicy>druid:ww057vk7675</adminPolicy>
         <otherId name="label"/>
         <otherId name="uuid">2d73ed30-9350-11e3-9ca2-0050569b3c3c</otherId>
         <sourceId source="sul">RBC_QA76.P396FF_5:3</sourceId>
         <tag>Process : Content Type : Book (flipbook, ltr)</tag>
         <tag> Project : Computer Newsletter and Magazine Digitization Project </tag>
         <tag>dpg : People's Computer Company</tag>
         <tag>Registered By : cheungd</tag>
         <tag>Remediated By : 4.20.0</tag>
         <release to="Searchworks">true</release>
       </identityMetadata>
       <contentMetadata objectId="cg160px5426" type="book">
         <resource id="cg160px5426_1" sequence="1" type="page">
           <label>Page 1</label>
           <file id="cg160px5426_06_0001.pdf" mimetype="application/pdf" size="1547618"/>
           <file id="cg160px5426_00_0001.jp2" mimetype="image/jp2" size="11475822">
             <imageData width="7031" height="8665"/>
           </file>
         </resource>
         <resource id="cg160px5426_2" sequence="2" type="page">
           <label>Page 2</label>
           <file id="cg160px5426_06_0002.pdf" mimetype="application/pdf" size="2000488"/>
           <file id="cg160px5426_00_0002.jp2" mimetype="image/jp2" size="11475464">
             <imageData width="7031" height="8665"/>
           </file>
         </resource>
         <resource id="cg160px5426_3" sequence="3" type="page">
           <label>Page 3</label>
           <file id="cg160px5426_06_0003.pdf" mimetype="application/pdf" size="2567246"/>
           <file id="cg160px5426_00_0003.jp2" mimetype="image/jp2" size="11475483">
             <imageData width="7031" height="8665"/>
           </file>
         </resource>
         <resource id="cg160px5426_4" sequence="4" type="page">
           <label>Page 4</label>
           <file id="cg160px5426_06_0004.pdf" mimetype="application/pdf" size="2250526"/>
           <file id="cg160px5426_00_0004.jp2" mimetype="image/jp2" size="11475662">
             <imageData width="7031" height="8665"/>
           </file>
         </resource>
         <resource id="cg160px5426_5" sequence="5" type="page">
           <label>Page 5</label>
           <file id="cg160px5426_06_0005.pdf" mimetype="application/pdf" size="2489004"/>
           <file id="cg160px5426_00_0005.jp2" mimetype="image/jp2" size="11475511">
             <imageData width="7031" height="8665"/>
           </file>
         </resource>
       </contentMetadata>
       <rightsMetadata>
           <access type="discover">
               <machine>
                   <world/>
               </machine>
           </access>
           <access type="read">
               <machine>
                   <world/>
               </machine>
           </access>
           <use>
               <human type="useAndReproduction"> Property rights reside with the repository. Literary
                   rights reside with the creators of the documents or their heirs. To obtain
                   permission to publish or reproduce, please contact the Public Services Librarian of
                   the Dept. of Special Collections (http://library.stanford.edu/spc). </human>
           </use>
           <use>
               <human type="creativeCommons"/>
               <machine type="creativeCommons"/>
           </use>
       </rightsMetadata>
       <rdf:RDF xmlns:fedora="info:fedora/fedora-system:def/relations-external#"
           xmlns:fedora-model="info:fedora/fedora-system:def/model#"
           xmlns:hydra="http://projecthydra.org/ns/relations#"
           xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
           <rdf:Description rdf:about="info:fedora/druid:cg160px5426">
               <fedora:isMemberOf rdf:resource="info:fedora/druid:cj445qq4021"/>
               <fedora:isMemberOfCollection rdf:resource="info:fedora/druid:cj445qq4021"/>
           </rdf:Description>
       </rdf:RDF>
       <oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/"
           xmlns:srw_dc="info:srw/schema/1/dc-schema"
           xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
           <dc:identifier>RBC_QA76.P396FF_5:3</dc:identifier>
           <dc:type>Text</dc:type>
           <dc:type>newsletters</dc:type>
           <dc:title>People's Computer Company. 5:3</dc:title>
           <dc:contributor>People's Computer Company (Creator)</dc:contributor>
           <dc:date>1976-11</dc:date>
           <dc:format>1 newsletter</dc:format>
           <dc:format>volume</dc:format>
           <dc:format>image/jpeg</dc:format>
           <dc:subject>Computer industry--United States--History</dc:subject>
           <dc:subject>Microelectronics industry</dc:subject>
           <dc:subject>People's Computer Company</dc:subject>
           <dc:language>eng</dc:language>
           <dc:relation type="collection">People's Computer Company</dc:relation>
       </oai_dc:dc>
       <releaseData>
           <release to="Searchworks">true</release>
       </releaseData>
     </publicObject>
    xml
  end

  def coll_issued_mods
    <<-xml
    <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3" version="3.4" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
      <titleInfo>
        <title>Collection Title</title>
      </titleInfo>
      <name type="personal" usage="primary">
        <namePart>Personal Name</namePart>
        <namePart type="date">1884-1938</namePart>
      </name>
      <typeOfResource collection="yes" manuscript="yes">mixed material</typeOfResource>
      <originInfo>
        <place>
          <placeTerm type="code" authority="marccountry">cau</placeTerm>
        </place>
        <dateIssued encoding="marc" point="start">1909</dateIssued>
        <dateIssued encoding="marc" point="end">1933</dateIssued>
        <issuance>monographic</issuance>
      </originInfo>
      <language>
        <languageTerm authority="iso639-2b" type="code">und</languageTerm>
      </language>
      <physicalDescription>
        <extent>Number of Boxes</extent>
      </physicalDescription>
      <abstract>Abstract Text</abstract>
      <note type="statement of responsibility" altRepGroup="00"/>
      <note type="biographical/historical">Biographical/Historical Note</note>
      <note>Note</note>
      <subject authority="lcsh">
        <geographic>Geographic Subject</geographic>
        <genre>Subject Genre</genre>
      </subject>
      <location>
        <physicalLocation>Physical Location</physicalLocation>
      </location>
      <relatedItem>
        <location>
          <url displayLabel="Finding aid">http://www.oac.cdlib.org/findaid/ark:/13030/c84t6gtv</url>
        </location>
      </relatedItem>
      <recordInfo>
        <descriptionStandard>dacs</descriptionStandard>
        <recordContentSource authority="marcorg">CSt-H</recordContentSource>
        <recordCreationDate encoding="marc">120521</recordCreationDate>
        <recordChangeDate encoding="iso8601">20120526011056.0</recordChangeDate>
        <recordIdentifier source="SIRSI">a9615156</recordIdentifier>
        <recordOrigin>Record Origin</recordOrigin>
      </recordInfo>
      <accessCondition type="copyright">Copyright and Access Conditions</accessCondition>
    </mods>
    xml
  end

  def coll_created_mods
    <<-xml
    <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3" version="3.4" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
      <titleInfo>
        <title>Collection Title</title>
      </titleInfo>
      <name type="personal" usage="primary">
        <namePart>Personal Name</namePart>
        <namePart type="date">1884-1938</namePart>
      </name>
      <typeOfResource collection="yes" manuscript="yes">mixed material</typeOfResource>
      <originInfo>
        <place>
          <placeTerm type="code" authority="marccountry">cau</placeTerm>
        </place>
        <dateCreated encoding="marc" point="start">1910</dateCreated>
        <dateCreated encoding="marc" point="end">1920</dateCreated>
        <issuance>monographic</issuance>
      </originInfo>
      <language>
        <languageTerm authority="iso639-2b" type="code">und</languageTerm>
      </language>
      <physicalDescription>
        <extent>Number of Boxes</extent>
      </physicalDescription>
      <abstract>Abstract Text</abstract>
      <note type="statement of responsibility" altRepGroup="00"/>
      <note type="biographical/historical">Biographical/Historical Note</note>
      <note>Note</note>
      <subject authority="lcsh">
        <geographic>Geographic Subject</geographic>
        <genre>Subject Genre</genre>
      </subject>
      <location>
        <physicalLocation>Physical Location</physicalLocation>
      </location>
      <relatedItem>
        <location>
          <url displayLabel="Finding aid">http://www.oac.cdlib.org/findaid/ark:/13030/c84t6gtv</url>
        </location>
      </relatedItem>
      <recordInfo>
        <descriptionStandard>dacs</descriptionStandard>
        <recordContentSource authority="marcorg">CSt-H</recordContentSource>
        <recordCreationDate encoding="marc">120521</recordCreationDate>
        <recordChangeDate encoding="iso8601">20120526011056.0</recordChangeDate>
        <recordIdentifier source="SIRSI">a9615156</recordIdentifier>
        <recordOrigin>Record Origin</recordOrigin>
      </recordInfo>
      <accessCondition type="copyright">Copyright and Access Conditions</accessCondition>
    </mods>
    xml
  end

  def coll_not_issued_created_mods
    <<-xml
    <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3" version="3.4" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
      <titleInfo>
        <title>Collection Title</title>
      </titleInfo>
      <name type="personal" usage="primary">
        <namePart>Personal Name</namePart>
        <namePart type="date">1884-1938</namePart>
      </name>
      <typeOfResource collection="yes" manuscript="yes">mixed material</typeOfResource>
      <originInfo>
        <place>
          <placeTerm type="code" authority="marccountry">cau</placeTerm>
        </place>
        <issuance>monographic</issuance>
      </originInfo>
      <language>
        <languageTerm authority="iso639-2b" type="code">und</languageTerm>
      </language>
      <physicalDescription>
        <extent>Number of Boxes</extent>
      </physicalDescription>
      <abstract>Abstract Text</abstract>
      <note type="statement of responsibility" altRepGroup="00"/>
      <note type="biographical/historical">Biographical/Historical Note</note>
      <note>Note</note>
      <subject authority="lcsh">
        <geographic>Geographic Subject</geographic>
        <genre>Subject Genre</genre>
      </subject>
      <location>
        <physicalLocation>Physical Location</physicalLocation>
      </location>
      <relatedItem>
        <location>
          <url displayLabel="Finding aid">http://www.oac.cdlib.org/findaid/ark:/13030/c84t6gtv</url>
        </location>
      </relatedItem>
      <recordInfo>
        <descriptionStandard>dacs</descriptionStandard>
        <recordContentSource authority="marcorg">CSt-H</recordContentSource>
        <recordCreationDate encoding="marc">120521</recordCreationDate>
        <recordChangeDate encoding="iso8601">20120526011056.0</recordChangeDate>
        <recordIdentifier source="SIRSI">a9615156</recordIdentifier>
        <recordOrigin>Record Origin</recordOrigin>
      </recordInfo>
      <accessCondition type="copyright">Copyright and Access Conditions</accessCondition>
    </mods>
    xml
  end

  def coll_neg_dates_mods
    <<-xml
    <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3" version="3.4" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
      <titleInfo>
        <title>Collection Title</title>
      </titleInfo>
      <name type="personal" usage="primary">
        <namePart>Personal Name</namePart>
        <namePart type="date">1884-1938</namePart>
      </name>
      <typeOfResource collection="yes" manuscript="yes">mixed material</typeOfResource>
      <originInfo>
        <place>
          <placeTerm type="code" authority="marccountry">cau</placeTerm>
        </place>
        <dateCreated encoding="marc" point="start">-100</dateCreated>
        <dateCreated encoding="marc" point="end">-50</dateCreated>
        <issuance>monographic</issuance>
      </originInfo>
      <language>
        <languageTerm authority="iso639-2b" type="code">und</languageTerm>
      </language>
      <physicalDescription>
        <extent>Number of Boxes</extent>
      </physicalDescription>
      <abstract>Abstract Text</abstract>
      <note type="statement of responsibility" altRepGroup="00"/>
      <note type="biographical/historical">Biographical/Historical Note</note>
      <note>Note</note>
      <subject authority="lcsh">
        <geographic>Geographic Subject</geographic>
        <genre>Subject Genre</genre>
      </subject>
      <location>
        <physicalLocation>Physical Location</physicalLocation>
      </location>
      <relatedItem>
        <location>
          <url displayLabel="Finding aid">http://www.oac.cdlib.org/findaid/ark:/13030/c84t6gtv</url>
        </location>
      </relatedItem>
      <recordInfo>
        <descriptionStandard>dacs</descriptionStandard>
        <recordContentSource authority="marcorg">CSt-H</recordContentSource>
        <recordCreationDate encoding="marc">120521</recordCreationDate>
        <recordChangeDate encoding="iso8601">20120526011056.0</recordChangeDate>
        <recordIdentifier source="SIRSI">a9615156</recordIdentifier>
        <recordOrigin>Record Origin</recordOrigin>
      </recordInfo>
      <accessCondition type="copyright">Copyright and Access Conditions</accessCondition>
    </mods>
    xml
  end

  def coll_image_xml
    <<-xml
    <publicObject id="druid:yg867hg1375" published="2015-02-26T10:50:07-08:00">
      <identityMetadata>
        <objectId>druid:oo000oo0000</objectId>
        <objectCreator>DOR</objectCreator>
        <objectLabel>Object Label</objectLabel>
        <objectType>collection</objectType>
        <displayType>image</displayType>
        <adminPolicy>druid:aa111bb2222</adminPolicy>
        <otherId name="catkey">9615156</otherId>
        <otherId name="uuid">8f1feb20-4b29-11e3-8e31-0050569b3c3c</otherId>
        <tag>Remediated By : 4.17.1</tag>
      </identityMetadata>
      <xml/>
      <rightsMetadata>
        <access type="discover">
          <machine>
            <world/>
          </machine>
        </access>
        <access type="read">
          <machine>
            <world/>
          </machine>
        </access>
        <use>
          <human type="useAndReproduction"/>
          <human type="creativeCommons"/>
          <machine type="creativeCommons"/>
        </use>
        <copyright>
          <human type="copyright">Copyright</human>
        </copyright>
      </rightsMetadata>
      <rdf:RDF xmlns:fedora-model="info:fedora/fedora-system:def/model#" xmlns:hydra="http://projecthydra.org/ns/relations#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
        <rdf:Description rdf:about="info:fedora/druid:oo000oo0000">
        </rdf:Description>
      </rdf:RDF>
      <oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:srw_dc="info:srw/schema/1/dc-schema" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
        <dc:title>DC title</dc:title>
        <dc:contributor>DC contributor</dc:contributor>
        <dc:type>Collection</dc:type>
        <dc:date>DC date</dc:date>
        <dc:language>DC language</dc:language>
        <dc:format>DC format</dc:format>
        <dc:description>DC description</dc:description>
        <dc:rights>DC rights</dc:rights>
        <dc:description type="biographical/historical">DC description Biographical/Historical</dc:description>
        <dc:description>DC description</dc:description>
        <dc:coverage>DC coverage</dc:coverage>
      </oai_dc:dc>
      <ReleaseDigest/>
    </publicObject>
    xml
  end
end
