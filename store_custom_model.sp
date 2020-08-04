#pragma semicolon 1
#include <sourcemod> 
#include <sdktools>
#include <cstrike>
#include <store> 
#include <zephstocks> 
#include <fpvm_interface>
#undef REQUIRE_PLUGIN
#include <weapons>

#pragma newdecls required
enum CustomModel
{
	String:szModel[PLATFORM_MAX_PATH],
	String:szWorldModel[PLATFORM_MAX_PATH],
	String:szDropModel[PLATFORM_MAX_PATH],
	String:weaponentity[32],
	iSlot,
	iCacheID,
	iCacheIDWorldModel
}

int g_eCustomModel[STORE_MAX_ITEMS][CustomModel];
int g_iCustomModels = 0;

int g_iActive[MAXPLAYERS+1];
bool g_bWeapons;

public Plugin myinfo =
{
	name = "Store Custom Weapon Models",
	author = "Mr.Derp & Franc1sco franug | Zephyrus Store Module & bbs.93x.net | KGNS Weapons Support & Cruze",
	description = "Store Custom Weapon Models for specific weapon",
	version = "3.1",
	url = "http://bbs.93x.net | http://steamcommunity.com/profiles/76561198132924835"
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	MarkNativeAsOptional("Weapons_GetClientKnife");
	MarkNativeAsOptional("Weapons_SetClientKnife");
	MarkNativeAsOptional("Weapons_RefreshClient");
	return APLRes_Success;
}

public void OnLibraryAdded(const char[] name)
{
	if(strcmp(name, "weapons") == 0)
	{
		g_bWeapons = true;
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if(strcmp(name, "weapons") == 0)
	{
		g_bWeapons = false;
	}
}

public void OnAllPluginsLoaded()
{
	g_bWeapons = LibraryExists("weapons");
}

public void OnPluginStart() 
{
	Store_RegisterHandler("CustomModel", "model", CustomModelOnMapStart, CustomModelReset, CustomModelConfig, CustomModelEquip, CustomModelRemove, true); 
}

public void CustomModelOnMapStart() 
{
	for(int i=0;i<g_iCustomModels;++i)
	{
		g_eCustomModel[i][iCacheID] = PrecacheModel2(g_eCustomModel[i][szModel], true);
		Downloader_AddFileToDownloadsTable(g_eCustomModel[i][szModel]);
		
		if(g_eCustomModel[i][szWorldModel][0]!=0)
		{
			g_eCustomModel[i][iCacheIDWorldModel] = PrecacheModel2(g_eCustomModel[i][szWorldModel], true);
			Downloader_AddFileToDownloadsTable(g_eCustomModel[i][szWorldModel]);
			
			if(g_eCustomModel[i][iCacheIDWorldModel] ==0)
				g_eCustomModel[i][iCacheIDWorldModel] = -1;
		}
		
		if(g_eCustomModel[i][szDropModel][0]!=0)
		{
			if(!IsModelPrecached(g_eCustomModel[i][szDropModel]))
			{
				PrecacheModel2(g_eCustomModel[i][szDropModel], true);
				Downloader_AddFileToDownloadsTable(g_eCustomModel[i][szDropModel]);
			}
		}
	}
}

public void CustomModelReset() 
{ 
	g_iCustomModels = 0; 
}

public int CustomModelConfig(Handle &kv, int itemid) 
{
	Store_SetDataIndex(itemid, g_iCustomModels);
	KvGetString(kv, "model", g_eCustomModel[g_iCustomModels][szModel], PLATFORM_MAX_PATH);
	KvGetString(kv, "worldmodel", g_eCustomModel[g_iCustomModels][szWorldModel], PLATFORM_MAX_PATH);
	KvGetString(kv, "dropmodel", g_eCustomModel[g_iCustomModels][szDropModel], PLATFORM_MAX_PATH);
	KvGetString(kv, "entity", g_eCustomModel[g_iCustomModels][weaponentity], 32);
	g_eCustomModel[g_iCustomModels][iSlot] = KvGetNum(kv, "slot");
	
	if(FileExists(g_eCustomModel[g_iCustomModels][szModel], true))
	{
		++g_iCustomModels;
		
		for(int i=0;i<g_iCustomModels;++i)
		{
			if(!IsModelPrecached(g_eCustomModel[i][szModel]))
			{
				g_eCustomModel[i][iCacheID] = PrecacheModel2(g_eCustomModel[i][szModel], true);
				Downloader_AddFileToDownloadsTable(g_eCustomModel[i][szModel]);
				//LogMessage("Precached %i %s",g_eCustomModel[i][iCacheID],g_eCustomModel[i][szModel]);
			}
			if(g_eCustomModel[i][szWorldModel][0]!=0)
			{
				if(!IsModelPrecached(g_eCustomModel[i][szWorldModel]))
				{	
					g_eCustomModel[i][iCacheIDWorldModel] = PrecacheModel2(g_eCustomModel[i][szWorldModel], true);
					Downloader_AddFileToDownloadsTable(g_eCustomModel[i][szWorldModel]);
					//LogMessage("Precached %i %s",g_eCustomModel[i][iCacheIDWorldModel],g_eCustomModel[i][szWorldModel]);
				}
				if(g_eCustomModel[i][szDropModel][0]!=0)
				{
					if(!IsModelPrecached(g_eCustomModel[i][szDropModel]))
					{
						PrecacheModel2(g_eCustomModel[i][szDropModel], true);
						Downloader_AddFileToDownloadsTable(g_eCustomModel[i][szDropModel]);
					}
				}
			}
		}
		
		return true;
	}
	return false;
}

public void OnClientPutInServer(int client)
{
	g_iActive[client] = -1;
}

public int CustomModelEquip(int client, int id)
{
	int m_iData = Store_GetDataIndex(id);
	g_iActive[client] = m_iData;
	if(g_bWeapons)
	{
		char buffer[64];
		Weapons_GetClientKnife(client, buffer, sizeof(buffer));
		if(strcmp(buffer, "weapon_knife") != 0)
		{
			Weapons_SetClientKnife(client, "weapon_knife", false);
		}
	}
	
	FPVMI_SetClientModel(client, g_eCustomModel[m_iData][weaponentity], g_eCustomModel[m_iData][iCacheID], g_eCustomModel[m_iData][iCacheIDWorldModel], g_eCustomModel[m_iData][szDropModel]);
	
	//PrintToChat(client,"%s %d %d %s",g_eCustomModel[m_iData][weaponentity], g_eCustomModel[m_iData][iCacheID], g_eCustomModel[m_iData][iCacheIDWorldModel],g_eCustomModel[m_iData][szDropModel]); //DEBUG
	return g_eCustomModel[m_iData][iSlot];
}

public int CustomModelRemove(int client, int id) 
{
	int m_iData = Store_GetDataIndex(id);
	
	FPVMI_RemoveViewModelToClient(client, g_eCustomModel[m_iData][weaponentity]);
	if(g_eCustomModel[m_iData][szWorldModel][0]!=0)
	{
		FPVMI_RemoveWorldModelToClient(client, g_eCustomModel[m_iData][weaponentity]);
	}
	if(g_eCustomModel[m_iData][szDropModel][0]!=0)
	{
		FPVMI_RemoveDropModelToClient(client, g_eCustomModel[m_iData][weaponentity]);
	}
	
	if(g_bWeapons)
	{
		Weapons_RefreshClient(client);
		char buffer[64];
		Weapons_GetClientKnife(client, buffer, sizeof(buffer));
		if(strcmp(buffer, "weapon_knife") != 0)
		{
			Weapons_SetClientKnife(client, buffer, false);
		}
	}
	
	g_iActive[client] = -1;
	
	PrintToChat(client, "[SM] Custom model un-equipped. Switch weapons to refresh!");
	
	return g_eCustomModel[m_iData][iSlot];
}

public Action Weapons_OnClientKnifeSelectPre(int client, int knifeId, char[] knifeName)
{
	if(g_iActive[client] == -1)
	{
		return Plugin_Continue;
	}
	if(strcmp(g_eCustomModel[g_iActive[client]][weaponentity], "weapon_knife") != 0)
	{
		return Plugin_Continue;
	}
	PrintToChat(client, "[SM] You can't change your knife with custom knife model equipped in store!");
	return Plugin_Handled;
}

public void OnMapStart() //Precache possible bug re check
{
	if(g_iCustomModels > 0)
	{
		for(int i=0;i<g_iCustomModels;++i)
		{
			if(!IsModelPrecached(g_eCustomModel[i][szModel]))
			{
				g_eCustomModel[i][iCacheID] = PrecacheModel2(g_eCustomModel[i][szModel], true);
				Downloader_AddFileToDownloadsTable(g_eCustomModel[i][szModel]);
			}
			
			if(g_eCustomModel[i][szWorldModel][0]!=0)
			{
				if(!IsModelPrecached(g_eCustomModel[i][szWorldModel]))
				{
					g_eCustomModel[i][iCacheIDWorldModel] = PrecacheModel2(g_eCustomModel[i][szWorldModel], true);
					Downloader_AddFileToDownloadsTable(g_eCustomModel[i][szWorldModel]);
					
					if(g_eCustomModel[i][iCacheIDWorldModel] ==0)
						g_eCustomModel[i][iCacheIDWorldModel] = -1;
				}
			}
			
			if(g_eCustomModel[i][szDropModel][0]!=0)
			{
				if(!IsModelPrecached(g_eCustomModel[i][szDropModel]))
				{	
					PrecacheModel2(g_eCustomModel[i][szDropModel], true);
					Downloader_AddFileToDownloadsTable(g_eCustomModel[i][szDropModel]);
				}
			}
		}
	}
}