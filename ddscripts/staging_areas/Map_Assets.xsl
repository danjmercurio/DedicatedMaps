<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet type="text/xsl" href="view.xsl"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>

  <!-- ignore -->
  <xsl:template match="CompanyCode"/>

  <!-- Fields we expect and don't need to rename -->
  <xsl:template match="dataroot">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- rename -->
  <xsl:template match="Ident">
    <access_id>
      <xsl:apply-templates/>
    </access_id>
  </xsl:template>

  <xsl:template match="ParentIdent">
    <parent_access_id>
      <xsl:apply-templates/>
    </parent_access_id>
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

  <xsl:template match="LocationCode">
    <staging_area_id>
      <xsl:apply-templates/>
    </staging_area_id>
  </xsl:template>

  <xsl:template match="AssetTypeCode">
    <staging_area_asset_type_id>
      <xsl:apply-templates/>
    </staging_area_asset_type_id>
  </xsl:template>

  <xsl:template match="MapAsset">
    <description>
      <xsl:apply-templates/>
    </description>
  </xsl:template>

  <xsl:template match="Photo">
    <image>
      <xsl:apply-templates/>
    </image>
  </xsl:template>

  <!-- Fields we don't expect will go into the staging_area_asset_details table -->
  <xsl:template match="*">
    <detail>
      <xsl:copy-of select="."/>
        <xsl:apply-templates/>
      </xsl:copy-of>
    </detail>
  </xsl:template>

</xsl:stylesheet>
