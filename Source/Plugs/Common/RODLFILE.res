        ��  ��                  _  0   ��
 R O D L F I L E                     <?xml version="1.0" encoding="utf-8"?>
<Library Name="MIT_Service" UID="{9EFB4070-F3EF-4F02-ACF0-00A22B2A64AB}" Version="3.0">
<Documentation><![CDATA[MIT Service Interface]]></Documentation>
<Services>
<Service Name="SrvConnection" UID="{EC3C2D79-1514-486F-9FB1-812C37B9EF38}">
<Documentation><![CDATA[Service For Login Verify,SweetHeart ETC.]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{3E08D66D-DFBE-485E-A65C-F5EC6DC9F7CF}">
<Operations>
<Operation Name="Action" UID="{5BE3709D-9AFA-4DF7-BA80-30C783A3E9A8}">
<Parameters>
<Parameter Name="Result" DataType="Boolean" Flag="Result">
</Parameter>
<Parameter Name="nFunName" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[Function Or Worker Name]]></Documentation>
</Parameter>
<Parameter Name="nData" DataType="AnsiString" Flag="InOut" >
<Documentation><![CDATA[[in]输入参数;[out]输出数据]]></Documentation>
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="SrvBusiness" UID="{9BDC9D97-E1D8-4791-A692-758EC0E6235F}">
<Documentation><![CDATA[Service For Business]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{6173318C-3ECB-4FA8-A32A-4FC64D22AFF5}">
<Operations>
<Operation Name="Action" UID="{D2302A81-D793-4DE6-A98F-1049AFEFF6E5}">
<Parameters>
<Parameter Name="Result" DataType="Boolean" Flag="Result">
</Parameter>
<Parameter Name="nFunName" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[Function Or Worker Name]]></Documentation>
</Parameter>
<Parameter Name="nData" DataType="AnsiString" Flag="InOut" >
<Documentation><![CDATA[[in]输入参数;[out]输出数据]]></Documentation>
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
</Services>
<Structs>
</Structs>
<Enums>
</Enums>
<Arrays>
</Arrays>
</Library>
