//----------------------------------- ͨ�� -------------------------------------
{.$DEFINE DEBUG}
//����ģʽ

{.$DEFINE TrialVersion}
//���ð汾

{$DEFINE UseReport}
//����֧��

{.$DEFINE RandomID}
//ʹ��������

{$DEFINE cxLibrary42}
//Ver4.2���뻷��

{.$DEFINE EnableBackupDB}
//�������ݿ�֧��
{.$DEFINE EnableDoubleDB}
//˫���ݿ�֧��

//---------------------------------- �м�� ------------------------------------
{.$DEFINE ClientMon}
//�����ػ��ͻ���

{$DEFINE HardMon}
//����Ӳ���ػ�

{.$DEFINE GenRODL}
//����RODL��Դ

{$DEFINE COM_MIT}
//����ϵͳģʽ

//ͨ���м��
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //�������ݿ�֧��
  {.$DEFINE ChannelPool}
  //����ͨ��֧��
  {.$DEFINE AutoChannel}
  //����ͨ��ƽ��
  {.$DEFINE SAP}
  //����SAP֧��
  {.$DEFINE ClientMon}
  //֧���ػ�����
{$ENDIF}

//--------------------------------- �ض�ϵͳ -----------------------------------
{.$DEFINE COMMON}
//ͨ�ð汾

{$DEFINE YNHT}
//�ض�ϵͳ

//��������
{$IFDEF DYGL}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE PrintGLF}
  //��ӡ��·��
  {$DEFINE TruckInNow}
  //������������,��Ҫ���ó����Ŷ�ģʽ
{$ENDIF}

//�綫����
{$IFDEF RDHX}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //�����ͷ
{$ENDIF}

//�°�����
{$IFDEF XAZL}
  {$DEFINE SyncRemote}
  //Զ��ͬ��
  {$DEFINE MicroMsg}
  //΢��֧��
  {$DEFINE BlueCard}
  //����̧��
{$ENDIF}

//��Դ����
{$IFDEF JYZL}
  {$DEFINE XAZL}
  //ʹ���°�
  {$DEFINE SyncRemote}
  //Զ��ͬ��
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE PrintBillMoney}
  //��ӡʱ�Խ��
  {$DEFINE HR1847}
  //�������𳵼�
{$ENDIF}

//���Ϻ���
{$IFDEF YNHT}
  {$DEFINE XAZL}
  //ʹ���°�
  {$DEFINE SyncRemote}
  //Զ��ͬ��
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE PrintBillMoney}
  //��ӡʱ�Խ��
  {$DEFINE MITTruckProber}
  //�������м������
{$ENDIF}
