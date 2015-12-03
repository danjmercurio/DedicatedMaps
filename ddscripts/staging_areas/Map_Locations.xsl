<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet type="text/xsl" href="view.xsl"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  
  <!-- ignore -->
  <xsl:template match="CompanyCode"/>
  
  <!-- Fields we expect and don't need to rename -->
  <xsl:template match="Contact | Address | City | State | Zip | Phone | FAX | Email | Icon | dataroot">
  	<xsl:copy>
 		<xsl:apply-templates/>
  	</xsl:copy>
  </xsl:template>

  <!-- Fields we want to rename -->
  <xsl:template match="*[starts-with(name(), 'qry_')]">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>

  <xsl:template match="*[starts-with(name(), 'tbl_')]">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>

  <xsl:template match="LocationName">
    <name>
      <xsl:apply-templates/>
    </name>
  </xsl:template>

  <xsl:template match="LocationCode">
    <access_id>
      <xsl:apply-templates/>
    </access_id>
  </xsl:template>

  <xsl:template match="Longitude">
    <lon>
      <xsl:apply-templates/>
    </lon>
  </xsl:template>

  <xsl:template match="Latitude">
    <lat>
      <xsl:apply-templates/>
    </lat>
  </xsl:template>

  <!-- Fields we don't expect will go into the staging_area_details table -->
  <xsl:template match="*">
  	<detail>
      <xsl:copy-of select="."/>
        <xsl:apply-templates/>
      </xsl:copy-of>
  	</detail>
  </xsl:template>

</xsl:stylesheet>
