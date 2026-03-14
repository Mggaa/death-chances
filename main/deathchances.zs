
class DeathChances : StaticEventHandler 
{
	int lifes;
	int wait;
	bool willSave;
	bool newScene;
	int saveTick;
	int ticksToSave;
	bool willReset;

	override void OnRegister()
	{
		ticksToSave = Cvar.GetCvar("secs_to_save").GetInt() * 35;
		lifes = Cvar.GetCvar("dc_max_lifes").GetInt();
		Console.printf("DeathChances registered");
	}
	
	override void WorldThingDied(WorldEvent e)
	{
		if (e.Thing && e.Thing.player)
		{
			lifes--;
			int pNumber = e.Thing.PlayerNumber();
			
			String pName = e.Thing.player.GetUserName();
			//Console.Printf("Player %d se fudeu (%s) vidas: %d",pNumber,pName,lifes);
			if (lifes <= 0)
			{
				LoserAnim();
			}
			else
			{
				e.Thing.A_Print(String.format("\cgRemaining lives: %d",lifes),10,"BigFont");
			}
			
		}
	}
	
	
	override void WorldLoaded(WorldEvent e)
	{
		if (willSave && !willReset) 
		{
			newScene = true;
		}
		if (willReset)
		{
			wait = 5;
		}
	}

	override void WorldTick()
	{
		// Lógica do Timer de Reset
		if (wait > 0)
		{
			wait--;
			if (wait == 0)
			{
				ReloadMap();
			}
		}

		// Lógica do Spawn na Nova Cena
		if (newScene) 
		{
			if (PlayerInGame[0] && players[0].mo)
			{
				SaveGame();
				willSave = false;
				newScene = false;
			}
		}
		
		// Lógica do AutoSave
		if (ticksToSave > 0)
		{
			saveTick++;
			if (saveTick >= ticksToSave)
			{
				SaveGame();
				saveTick = 0;
			}
		}
	}
	
	void LoserAnim() 
	{
		//Console.printf("Isso foi disparado agr");
		PlayerPawn player = players[0].mo;
		player.A_PrintBold("Game over reseting level",20,"BigFont");
				
		player.A_StartSound("loser/haha",CHAN_AUTO);
		lifes = Cvar.GetCvar("dc_max_lifes").GetInt();
		//Console.printf("level reset");
		willSave = true;
		willReset = true;
		wait = 50;
    
	}
	void SaveGame()
	{
		if (PlayerInGame[0] && players[0].mo)
		{
			Actor a = Actor.Spawn("SaveCaller", players[0].mo.pos);
			Console.printf("Summoned caller");
		}
	}
	
	void ReloadMap()
	{
		willReset = false;
		Level.ChangeLevel(level.MapName, 0);
	}
	
}



class SaveCaller : Actor {
	override void BeginPlay()
	{
		Console.printf("Saving..");
		ACS_NamedExecuteAlways("DoAutoSave");
		Destroy();
		
	}
}

