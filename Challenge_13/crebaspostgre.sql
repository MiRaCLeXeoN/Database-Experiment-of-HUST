/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     2022/11/24 13:27:58                          */
/*==============================================================*/


drop table apgroup;

drop table apmodule;

drop table apright;

drop table aprole;

drop table apuser;

/*==============================================================*/
/* Table: aprole                                                */
/*==============================================================*/
create table aprole (
   RoleNo               INT4                 not null,
   RoleName             CHAR(20)             not null,
   Comment              VARCHAR(50)          null default NULL,
   Status               INT2                 null default NULL,
   constraint PK_APROLE primary key (RoleNo)
);

comment on column aprole.RoleNo is
'��ɫ���';

comment on column aprole.RoleName is
'��ɫ��';

comment on column aprole.Comment is
'��ɫ����';

comment on column aprole.Status is
'��ɫ״̬';

/*==============================================================*/
/* Table: apuser                                                */
/*==============================================================*/
create table apuser (
   UserID               CHAR(8)              not null,
   UserName             CHAR(8)              null default NULL,
   Comment              VARCHAR(50)          null default NULL,
   PassWord             CHAR(32)             null default NULL,
   Status               INT2                 null default NULL,
   constraint PK_APUSER primary key (UserID),
   constraint ind_username unique (UserName)
);

comment on column apuser.UserID is
'�û�����';

comment on column apuser.UserName is
'�û�����';

comment on column apuser.Comment is
'�û�����';

comment on column apuser.PassWord is
'����';

comment on column apuser.Status is
'״̬';

/*==============================================================*/
/* Table: apgroup                                               */
/*==============================================================*/
create table apgroup (
   UserID               CHAR(8)              not null,
   RoleNo               INT4                 not null,
   constraint PK_APGROUP primary key (UserID, RoleNo),
   constraint FK_apGroup_apRole2 unique (RoleNo),
   constraint FK_apGroup_apRole foreign key (RoleNo)
      references aprole (RoleNo),
   constraint FK_apGroup_apUser foreign key (UserID)
      references apuser (UserID)
);

comment on column apgroup.UserID is
'�û����';

comment on column apgroup.RoleNo is
'��ɫ���';

/*==============================================================*/
/* Table: apmodule                                              */
/*==============================================================*/
create table apmodule (
   ModNo                INT8                 not null,
   ModID                CHAR(10)             null default NULL,
   ModName              CHAR(20)             null default NULL,
   constraint PK_APMODULE primary key (ModNo)
);

comment on column apmodule.ModNo is
'ģ����';

comment on column apmodule.ModID is
'ϵͳ��ģ��Ĵ���';

comment on column apmodule.ModName is
'ϵͳ��ģ�������';

/*==============================================================*/
/* Table: apright                                               */
/*==============================================================*/
create table apright (
   RoleNo               INT4                 not null,
   ModNo                INT8                 not null,
   constraint PK_APRIGHT primary key (RoleNo, ModNo),
   constraint FK_apRight_apModule2 unique (ModNo),
   constraint FK_apRight_apModule foreign key (ModNo)
      references apmodule (ModNo),
   constraint FK_apRight_apRole foreign key (RoleNo)
      references aprole (RoleNo)
);

comment on column apright.RoleNo is
'��ɫ���';

comment on column apright.ModNo is
'ģ����';
