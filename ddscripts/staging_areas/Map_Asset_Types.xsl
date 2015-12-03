<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet type="text/xsl" href="view.xsl"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>

  <!-- ignore -->
  <xsl:template match="CompanyCode"/>

  <!-- rename --> 
  <xsl:template match="AssetTypeCode">
    <access_id>
      <xsl:apply-templates/>
    </access_id>
  </xsl:template>

  <xsl:template match="AssetTypeName">
    <name>
      <xsl:apply-templates/>
    </name>
  </xsl:template>
  
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

  <!-- everything else -->
  <xsl:template match="*">
     <xsl:copy>
      <xsl:apply-templates/>
     </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
