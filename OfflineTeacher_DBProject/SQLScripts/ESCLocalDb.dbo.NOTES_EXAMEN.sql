/****
This SQL script was generated by the Configure Data Synchronization
dialog box. This script contains statements that create the
change-tracking columns, deleted-items table, and triggers on the
server database. These database objects are required by Synchronization
Services to successfully synchronize data between client and server
databases. For more information, see the
‘How to: Configure a Database Server for Synchronization’ topic in Help.
****/


IF @@TRANCOUNT > 0
set ANSI_NULLS ON 
set QUOTED_IDENTIFIER ON 

GO
BEGIN TRANSACTION;


IF @@TRANCOUNT > 0
ALTER TABLE [dbo].[NOTES_EXAMEN] 
ADD [LastEditDate] DateTime NULL CONSTRAINT [DF_NOTES_EXAMEN_LastEditDate] DEFAULT (GETUTCDATE()) WITH VALUES
GO
IF @@ERROR <> 0 
     ROLLBACK TRANSACTION;


IF @@TRANCOUNT > 0
ALTER TABLE [dbo].[NOTES_EXAMEN] 
ADD [CreationDate] DateTime NULL CONSTRAINT [DF_NOTES_EXAMEN_CreationDate] DEFAULT (GETUTCDATE()) WITH VALUES
GO
IF @@ERROR <> 0 
     ROLLBACK TRANSACTION;


IF @@TRANCOUNT > 0
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NOTES_EXAMEN_Tombstone]')) 
BEGIN 
CREATE TABLE [dbo].[NOTES_EXAMEN_Tombstone]( 
    [ID_ETUDIANT] Int NOT NULL,
    [ANNEE_UNIVERSITAIRE] Int NOT NULL,
    [ID_MATIERE] Int NOT NULL,
    [ID_EXAMEN] Int NOT NULL,
    [DeletionDate] DateTime NULL
)END 

GO
IF @@ERROR <> 0 
     ROLLBACK TRANSACTION;


IF @@TRANCOUNT > 0
ALTER TABLE [dbo].[NOTES_EXAMEN_Tombstone] ADD CONSTRAINT [PKDEL_NOTES_EXAMEN_Tombstone_ID_ETUDIANTANNEE_UNIVERSITAIREID_MATIEREID_EXAMEN]
   PRIMARY KEY CLUSTERED
    ([ID_ETUDIANT], [ANNEE_UNIVERSITAIRE], [ID_MATIERE], [ID_EXAMEN])
GO
IF @@ERROR <> 0 
     ROLLBACK TRANSACTION;


IF @@TRANCOUNT > 0
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NOTES_EXAMEN_DeletionTrigger]') AND type = 'TR') 
   DROP TRIGGER [dbo].[NOTES_EXAMEN_DeletionTrigger] 

GO
CREATE TRIGGER [dbo].[NOTES_EXAMEN_DeletionTrigger] 
    ON [NOTES_EXAMEN] 
    AFTER DELETE 
AS 
SET NOCOUNT ON 
UPDATE [dbo].[NOTES_EXAMEN_Tombstone] 
    SET [DeletionDate] = GETUTCDATE() 
    FROM deleted 
    WHERE deleted.[ID_ETUDIANT] = [NOTES_EXAMEN_Tombstone].[ID_ETUDIANT] 
    AND deleted.[ANNEE_UNIVERSITAIRE] = [NOTES_EXAMEN_Tombstone].[ANNEE_UNIVERSITAIRE] 
    AND deleted.[ID_MATIERE] = [NOTES_EXAMEN_Tombstone].[ID_MATIERE] 
    AND deleted.[ID_EXAMEN] = [NOTES_EXAMEN_Tombstone].[ID_EXAMEN] 
IF @@ROWCOUNT = 0 
BEGIN 
    INSERT INTO [dbo].[NOTES_EXAMEN_Tombstone] 
    ([ID_ETUDIANT], [ANNEE_UNIVERSITAIRE], [ID_MATIERE], [ID_EXAMEN], DeletionDate)
    SELECT [ID_ETUDIANT], [ANNEE_UNIVERSITAIRE], [ID_MATIERE], [ID_EXAMEN], GETUTCDATE()
    FROM deleted 
END 

GO
IF @@ERROR <> 0 
     ROLLBACK TRANSACTION;


IF @@TRANCOUNT > 0
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NOTES_EXAMEN_UpdateTrigger]') AND type = 'TR') 
   DROP TRIGGER [dbo].[NOTES_EXAMEN_UpdateTrigger] 

GO
CREATE TRIGGER [dbo].[NOTES_EXAMEN_UpdateTrigger] 
    ON [dbo].[NOTES_EXAMEN] 
    AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON 
    UPDATE [dbo].[NOTES_EXAMEN] 
    SET [LastEditDate] = GETUTCDATE() 
    FROM inserted 
    WHERE inserted.[ID_ETUDIANT] = [NOTES_EXAMEN].[ID_ETUDIANT] 
    AND inserted.[ANNEE_UNIVERSITAIRE] = [NOTES_EXAMEN].[ANNEE_UNIVERSITAIRE] 
    AND inserted.[ID_MATIERE] = [NOTES_EXAMEN].[ID_MATIERE] 
    AND inserted.[ID_EXAMEN] = [NOTES_EXAMEN].[ID_EXAMEN] 
END;
GO
IF @@ERROR <> 0 
     ROLLBACK TRANSACTION;


IF @@TRANCOUNT > 0
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NOTES_EXAMEN_InsertTrigger]') AND type = 'TR') 
   DROP TRIGGER [dbo].[NOTES_EXAMEN_InsertTrigger] 

GO
CREATE TRIGGER [dbo].[NOTES_EXAMEN_InsertTrigger] 
    ON [dbo].[NOTES_EXAMEN] 
    AFTER INSERT 
AS 
BEGIN 
    SET NOCOUNT ON 
    UPDATE [dbo].[NOTES_EXAMEN] 
    SET [CreationDate] = GETUTCDATE() 
    FROM inserted 
    WHERE inserted.[ID_ETUDIANT] = [NOTES_EXAMEN].[ID_ETUDIANT] 
    AND inserted.[ANNEE_UNIVERSITAIRE] = [NOTES_EXAMEN].[ANNEE_UNIVERSITAIRE] 
    AND inserted.[ID_MATIERE] = [NOTES_EXAMEN].[ID_MATIERE] 
    AND inserted.[ID_EXAMEN] = [NOTES_EXAMEN].[ID_EXAMEN] 
END;
GO
IF @@ERROR <> 0 
     ROLLBACK TRANSACTION;
COMMIT TRANSACTION;