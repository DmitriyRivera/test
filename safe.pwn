#define dialog_safe_gun			8000
#define dialog_safe_drugs		8001
#define dialog_safe_money		8002
#define dialog_safe_materials	8003
#define dialog_safe_select_gun	8004

CMD:testsafe(playerid)
{
	  if(!PlayerInfo[playerid][pHouse]) 
		  return SendClientMessage(playerid, -1, "У Вас нет дома");
	
	if(!GetPVarInt(playerid, "safe:show"))
		ShowSafe(playerid, true);
	else
		ShowSafe(playerid, false);
	
	return 1;
}

stock ShowSafe(playerid, status, select = 0)
{
	if(status)
	{
	    new h = PlayerInfo[playerid][pHouse];
	    
		  for(new i; i < 10; i++)
			  TextDrawShowForPlayer(playerid, global_safe_td[i]);

		for(new i; i < 4; i++)
		{
		    switch(i)
			{
				case 0:
				{
				    format(stringer, sizeof(stringer), "%d / %d / %d", HouseInfo[h][safe_ammunitions][0], HouseInfo[h][safe_ammunitions][1], HouseInfo[h][safe_ammunitions][2]);
					  PlayerTextDrawSetString(playerid, player_safe_td[playerid][i], stringer);
				}
				case 1:
				{
				    format(stringer, sizeof(stringer), "%d", HouseInfo[h][safe_materials]);
					  PlayerTextDrawSetString(playerid, player_safe_td[playerid][i], stringer);
				}
				case 2:
				{
				    format(stringer, sizeof(stringer), "%d ™.", HouseInfo[h][safe_drugs]);
					  PlayerTextDrawSetString(playerid, player_safe_td[playerid][i], stringer);
				}
				case 3:
				{
				    format(stringer, sizeof(stringer), "$%d", HouseInfo[h][safe_money]);
					  PlayerTextDrawSetString(playerid, player_safe_td[playerid][i], stringer);
				}
			}
			PlayerTextDrawShow(playerid, player_safe_td[playerid][i]);
		}

		SetPVarInt(playerid, "safe:show", 1);
		SelectTextDraw(playerid, 0xE1E1E1AA);
	}
	else
	{
		for(new i; i < 10; i++)
			TextDrawHideForPlayer(playerid, global_safe_td[i]);

		for(new i; i < 4; i++)
			PlayerTextDrawHide(playerid, player_safe_td[playerid][i]);

		DeletePVar(playerid, "safe:show");

		if(select)
		{
			    CancelSelectTextDraw(playerid);

	        DeletePVar(playerid, "safe:preview");
	        DeletePVar(playerid, "safe:index");
	        DeletePVar(playerid, "safe:dialog");
	        DeletePVar(playerid, "safe:gunslot");
		}
	}
	return 1;
}

stock ShowLocalSafe(playerid, preview_model, status, select = 0)
{
	new index = GetPVarInt(playerid, "safe:index");
	
	if(status)
	{
	    switch(preview_model)
	    {
	        case 321..372, 2041:
	        {
            for(new i; i < 7; i++)
            {
                if(index == 0 && i == 6) // не показываем левую стрелку (если первый слот)
                continue;

              if(index == 2 && i == 5) // не показываем правую стрелку (если последний слот)
                  continue;

              TextDrawShowForPlayer(playerid, global_local_safe_td[i]);
            }
	        }
	        default:
	        {
            for(new i; i < 7; i++)
            {
              if(i == 6 || i == 5) // не показываем стрелки (если выбраны не патроны)
                continue;

              TextDrawShowForPlayer(playerid, global_local_safe_td[i]);
            }
	        }
	    }
		for(new i; i < 4; i++)
		{
		    switch(i)
		    {
		    	case 0:
		    	{
					new h = PlayerInfo[playerid][pHouse];
					
		    	    switch(preview_model)
		    	    {
						case 321..372, 2041: // патроны
						{
						    format(stringer, sizeof(stringer), "%d", HouseInfo[h][safe_ammunitions][index]);
							PlayerTextDrawSetString(playerid, player_local_safe_td[playerid][i], stringer);
							
							if(preview_model != 2041)
							{
								format(stringer, sizeof(stringer), "%s", FixText(weapon_names[HouseInfo[h][safe_gun][index]]));
								PlayerTextDrawSetString(playerid, player_local_safe_td[playerid][2], stringer);
							}
							else
		                        PlayerTextDrawSetString(playerid, player_local_safe_td[playerid][2], FixText("Пусто"));
						}
						case 1579: // материалы
						{
						    format(stringer, sizeof(stringer), "%d", HouseInfo[h][safe_materials]);
							PlayerTextDrawSetString(playerid, player_local_safe_td[playerid][i], stringer);
							
							PlayerTextDrawSetString(playerid, player_local_safe_td[playerid][2], FixText("Материалы"));
						}
						case 1578: // наркотики
						{
						    format(stringer, sizeof(stringer), "%d ™.", HouseInfo[h][safe_drugs]);
							PlayerTextDrawSetString(playerid, player_local_safe_td[playerid][i], stringer);
							
							PlayerTextDrawSetString(playerid, player_local_safe_td[playerid][2], FixText("Наркотики"));
						}
						case 1212: // деньги
						{
						    format(stringer, sizeof(stringer), "$%d", HouseInfo[h][safe_money]);
							PlayerTextDrawSetString(playerid, player_local_safe_td[playerid][i], stringer);
							
							PlayerTextDrawSetString(playerid, player_local_safe_td[playerid][2], FixText("Деньги"));
						}
					}
					PlayerTextDrawShow(playerid, player_local_safe_td[playerid][i]);
				}
		    	case 1:
				{
				    switch(preview_model)
				    {
				        case 321..372: PlayerTextDrawSetPreviewRot(playerid, player_local_safe_td[playerid][i], 0.0, 0.0, 70.0, 2.0);
				        default: PlayerTextDrawSetPreviewRot(playerid, player_local_safe_td[playerid][i], -45.000000, 0.000000, 45.000000, 1.250000);
				    }
				    
				    PlayerTextDrawSetPreviewModel(playerid, player_local_safe_td[playerid][i], preview_model);
				    PlayerTextDrawShow(playerid, player_local_safe_td[playerid][i]);
				}
				case 2, 3: PlayerTextDrawShow(playerid, player_local_safe_td[playerid][i]);
			}
		}
		
		SetPVarInt(playerid, "safe:preview", preview_model);
		
		SetPVarInt(playerid, "localsafe:show", 1);
		SelectTextDraw(playerid, 0xE1E1E1AA);
	}
	else
	{
		for(new i; i < 7; i++)
		    TextDrawHideForPlayer(playerid, global_local_safe_td[i]);
		    
		for(new i; i < 4; i++)
		    PlayerTextDrawHide(playerid, player_local_safe_td[playerid][i]);
        
		if(select)
		{
			DeletePVar(playerid, "localsafe:show");
	        DeletePVar(playerid, "safe:preview");
	        DeletePVar(playerid, "safe:index");
	        DeletePVar(playerid, "safe:dialog");
	        DeletePVar(playerid, "safe:gunslot");

			CancelSelectTextDraw(playerid);
		}
	}
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid == player_local_safe_td[playerid][3]) // крестик локальный
	{
		if(GetPVarInt(playerid, "localsafe:show"))
		{
		    ShowLocalSafe(playerid, 0, false);

			DeletePVar(playerid, "localsafe:show");
	        DeletePVar(playerid, "safe:preview");
	        DeletePVar(playerid, "safe:index");
	        DeletePVar(playerid, "safe:dialog");
	        DeletePVar(playerid, "safe:gunslot");

		    ShowSafe(playerid, true);
		}
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	/*format(stringer, sizeof(stringer), "clickedid = %d", _:clickedid);
	SendClientMessage(playerid, -1, stringer);*/
	
	if(GetPVarInt(playerid, "safe:dialog") > 0)
	    return 1;
	
	if(clickedid == INVALID_TEXT_DRAW || clickedid == global_safe_td[4])
	{
		if(GetPVarInt(playerid, "safe:show"))
		    ShowSafe(playerid, false, 1);

		if(GetPVarInt(playerid, "localsafe:show"))
		{
		    ShowLocalSafe(playerid, 0, false);

			DeletePVar(playerid, "localsafe:show");
	        DeletePVar(playerid, "safe:preview");
	        DeletePVar(playerid, "safe:index");
	        DeletePVar(playerid, "safe:dialog");
	        DeletePVar(playerid, "safe:gunslot");

		    ShowSafe(playerid, true);
		}
	}
	else if(clickedid == global_safe_td[8]) // деньги
	{
	    ShowSafe(playerid, false);
		ShowLocalSafe(playerid, 1212, true);
	}
	else if(clickedid == global_safe_td[7]) // наркотики
	{
	    ShowSafe(playerid, false);
		ShowLocalSafe(playerid, 1578, true);
	}
	else if(clickedid == global_safe_td[6]) // материалы
	{
	    ShowSafe(playerid, false);
		ShowLocalSafe(playerid, 1579, true);
	}
	else if(clickedid == global_safe_td[5]) // патроны
	{
	    new h = PlayerInfo[playerid][pHouse];

		ShowSafe(playerid, false);
		
		SetPVarInt(playerid, "safe:index", 0);

		if(!HouseInfo[h][safe_gun][0])
            ShowLocalSafe(playerid, 2041, true);
		else
	    	ShowLocalSafe(playerid, GetWeaponModelD(HouseInfo[h][safe_gun][0]), true);
	}
	else if(clickedid == global_local_safe_td[4]) // взять ( 1 )
	{
		switch(GetPVarInt(playerid, "safe:preview"))
		{
		    case 1212:
		    {
		        if(!HouseInfo[PlayerInfo[playerid][pHouse]][safe_money])
					return SendClientMessage(playerid, COLOR_GRAY, "В сейфе нет денег.");
					
                ShowLocalSafe(playerid, 0, false);
		        
		        format(stringer, sizeof(stringer), "{FFFFFF}Деньги ($%d)", HouseInfo[PlayerInfo[playerid][pHouse]][safe_money]);
				ShowPlayerDialog(playerid, dialog_safe_money, DIALOG_STYLE_INPUT, stringer, "Укажите количество изымаемых денег:", "Далее", "Назад");
			}
			case 1578:
			{
			    ShowLocalSafe(playerid, 0, false);
			
		        format(stringer, sizeof(stringer), "{FFFFFF}Доступно: %d грамм\nУкажите количество, которое хотите взять:", HouseInfo[PlayerInfo[playerid][pHouse]][safe_drugs]);
				ShowPlayerDialog(playerid, dialog_safe_drugs, DIALOG_STYLE_INPUT, "Наркотики", stringer, "Взять", "Отмена");
			}
			case 1579:
			{
			    ShowLocalSafe(playerid, 0, false);
			
		        format(stringer, sizeof(stringer), "{FFFFFF}Доступно: %d материалов\nУкажите количество, которое хотите взять:", HouseInfo[PlayerInfo[playerid][pHouse]][safe_materials]);
				ShowPlayerDialog(playerid, dialog_safe_materials, DIALOG_STYLE_INPUT, "Материалы", stringer, "Взять", "Отмена");
			}
			case 321..372, 2041:
			{
			    if(GetPVarInt(playerid, "safe:preview") == 2041)
					return SendClientMessage(playerid, COLOR_GRAY, "В сейфе нет оружия.");
			
			    new h = PlayerInfo[playerid][pHouse],
					index = GetPVarInt(playerid, "safe:index");
					
                ShowLocalSafe(playerid, 0, false);
				
		        format(stringer, sizeof(stringer), "{FFFFFF}Оружие: %s\nДоступно: %d патронов\n\nУкажите количество, которое хотите взять:", weapon_names[HouseInfo[h][safe_gun][index]], HouseInfo[h][safe_ammunitions][index]);
				ShowPlayerDialog(playerid, dialog_safe_gun, DIALOG_STYLE_INPUT, "Патроны", stringer, "Взять", "Отмена");
			}
		}
		SetPVarInt(playerid, "safe:dialog", 1);
	}
	else if(clickedid == global_local_safe_td[3]) // положить ( 2 )
	{
		switch(GetPVarInt(playerid, "safe:preview"))
		{
		    case 1212:
		    {
				if(!PlayerInfo[playerid][pMoney])
				    return SendClientMessage(playerid, COLOR_GRAY, "У вас нет денег.");
				    
                ShowLocalSafe(playerid, 0, false);
				    
		        format(stringer, sizeof(stringer), "{FFFFFF}Деньги ($%d)", HouseInfo[PlayerInfo[playerid][pHouse]][safe_money]);
				ShowPlayerDialog(playerid, dialog_safe_money, DIALOG_STYLE_INPUT, stringer, "Укажите количество сохраняемых денег:", "Далее", "Назад");
			}
			case 1578:
			{
			    ShowLocalSafe(playerid, 0, false);
			
		        format(stringer, sizeof(stringer), "{FFFFFF}В сейфе: %d грамм\nУкажите количество, которое хотите положить:", HouseInfo[PlayerInfo[playerid][pHouse]][safe_drugs]);
				ShowPlayerDialog(playerid, dialog_safe_drugs, DIALOG_STYLE_INPUT, "Наркотики", stringer, "Далее", "Отмена");
			}
			case 1579:
			{
			    ShowLocalSafe(playerid, 0, false);
			
		        format(stringer, sizeof(stringer), "{FFFFFF}В сейфе: %d материалов\nУкажите количество, которое хотите положить:", HouseInfo[PlayerInfo[playerid][pHouse]][safe_materials]);
				ShowPlayerDialog(playerid, dialog_safe_materials, DIALOG_STYLE_INPUT, "Материалы", stringer, "Далее", "Отмена");
			}
			case 321..372, 2041:
			{
				new weaponid,
					ammo,
					count,
					index = GetPVarInt(playerid, "safe:index"),
					h = PlayerInfo[playerid][pHouse];
					
			    if(GetPVarInt(playerid, "safe:preview") == 2041)
				{
					format(stringer, sizeof(stringer), "{FFFFFF}Слот\t{FFFFFF}Оружие\t{FFFFFF}Патроны\n");

				    for(new slotid = 0; slotid <= 12; slotid++)
				    {
				        GetPlayerWeaponData(playerid, slotid, weaponid, ammo);

						if(weaponid == 0 || ammo == 0)
				            continue;

				        switch (weaponid)
				        {
				            case 1..15, 40, 45, 46:
				            {
				                format(stringer, sizeof(stringer), "%s%d\t%s\tX\n", stringer, slotid, weapon_names[weaponid]);
				                safe_list[playerid][count] = slotid;
				                count++;
				                continue;
				            }
				        }
				        format(stringer, sizeof(stringer), "%s%d\t%s\t%d\n", stringer, slotid, weapon_names[weaponid], ammo);
		                safe_list[playerid][count] = slotid;
		                count++;
				    }
				    if(count == 0)
						return SendClientMessage(playerid, COLOR_GRAY, "У вас нет оружия.");
						
					ShowLocalSafe(playerid, 0, false);

				    ShowPlayerDialog(playerid, dialog_safe_select_gun, DIALOG_STYLE_TABLIST_HEADERS, "Выбор оружия", stringer, "Выбрать", "Отмена");
				}
				else
				{
				    for(new slotid = 0; slotid <= 12; slotid++)
				    {
				        GetPlayerWeaponData(playerid, slotid, weaponid, ammo);

						if(weaponid != HouseInfo[h][safe_gun][index])
				            continue;
				            
						SetPVarInt(playerid, "safe:gunslot", slotid);
						count = 1;
						break;
					}
					if(!count || !ammo)
					    return SendClientMessage(playerid, COLOR_GRAY, "У вас нет подходящих патронов.");
					    
                    ShowLocalSafe(playerid, 0, false);

				    format(stringer, sizeof(stringer), "{FFFFFF}Выбрано оружие: %s\nДоступно патронов: %d\nВ сейфе: %d\nУкажите количество патронов, которое хотите добавить в сейф:", weapon_names[weaponid], ammo, HouseInfo[h][safe_ammunitions][index]);
				    ShowPlayerDialog(playerid, dialog_safe_gun, DIALOG_STYLE_INPUT, "Оружие", stringer, "Далее", "Отмена");

					SetPVarInt(playerid, "safe:dialog", 3);

					return 1;
				}
			}
		}
		SetPVarInt(playerid, "safe:dialog", 2);
	}
	else if(clickedid == global_local_safe_td[5]) // вправо
	{
	    new index = GetPVarInt(playerid, "safe:index"),
			h = PlayerInfo[playerid][pHouse];
			
        ShowLocalSafe(playerid, 0, false);
        
        SetPVarInt(playerid, "safe:index", index+1);
			
		if(!HouseInfo[h][safe_gun][index+1])
			ShowLocalSafe(playerid, 2041, true);
		else
			ShowLocalSafe(playerid, GetWeaponModelD(HouseInfo[h][safe_gun][index+1]), true);
		
	}
	else if(clickedid == global_local_safe_td[6]) // влево
	{
	    new index = GetPVarInt(playerid, "safe:index"),
			h = PlayerInfo[playerid][pHouse];
			
	    ShowLocalSafe(playerid, 0, false);
	    
	    SetPVarInt(playerid, "safe:index", index-1);

		if(!HouseInfo[h][safe_gun][index-1])
   			ShowLocalSafe(playerid, 2041, true);
		else
      		ShowLocalSafe(playerid, GetWeaponModelD(HouseInfo[h][safe_gun][index-1]), true);
				
	}
	    
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(listitem)
	{
		case dialog_safe_select_gun:
		{
		    if(!response)
		    {
		        DeletePVar(playerid, "safe:preview");
		        DeletePVar(playerid, "safe:dialog");
		        ShowLocalSafe(playerid, GetWeaponModelD(HouseInfo[PlayerInfo[playerid][pHouse]][safe_gun][GetPVarInt(playerid, "safe:index")]), true);
		        return 1;
		    }
		    new weaponid,
		        ammos;
		        
		    GetPlayerWeaponData(playerid, safe_list[playerid][listitem], weaponid, ammos);

			SetPVarInt(playerid, "safe:gunslot", safe_list[playerid][listitem]);

		    ShowPlayerDialog(playerid, dialog_safe_gun, DIALOG_STYLE_INPUT, "Оружие", "Укажите количество патронов, которое хотите положить:", "Далее", "Назад");
		}
		case dialog_safe_gun:
		{
		    if(!response)
		    {
		        DeletePVar(playerid, "safe:dialog");
		        DeletePVar(playerid, "safe:gunslot");
		        ShowLocalSafe(playerid, GetWeaponModelD(HouseInfo[PlayerInfo[playerid][pHouse]][safe_gun][GetPVarInt(playerid, "safe:index")]), true);
		        return 1;
		    }
		    
		    if(!strval(inputtext))
		        return ShowPlayerDialog(playerid, dialog_safe_gun, DIALOG_STYLE_INPUT, "Оружие", "Укажите количество патронов:", "Далее", "Назад");
		
		    if(GetPVarInt(playerid, "safe:dialog") == 1) // взять
		    {
		        new	input = strval(inputtext),
					h = PlayerInfo[playerid][pHouse],
					index = GetPVarInt(playerid, "safe:index");
					
				if(input > HouseInfo[h][safe_ammunitions][index])
				    return ShowPlayerDialog(playerid, dialog_safe_gun, DIALOG_STYLE_INPUT, "Оружие", "Укажите количество патронов, которое хотите взять:", "Далее", "Назад");
				
			    format(stringer, sizeof(stringer), "Вы взяли из сейфа %s с количеством патронов %d", weapon_names[HouseInfo[h][safe_gun][index]], input);
			    SendClientMessage(playerid, -1, stringer);
				GivePlayerWeapon(playerid, HouseInfo[h][safe_gun][index], input);
					
				HouseInfo[h][safe_ammunitions][index] -= input;
				
				if(HouseInfo[h][safe_ammunitions][index] <= 0)
				{
				    HouseInfo[h][safe_gun][index] = 0;
				    ShowLocalSafe(playerid, 0, false);
				    ShowLocalSafe(playerid, 2041, true);
				}
				else
				{
				    ShowLocalSafe(playerid, 0, false);
				    ShowLocalSafe(playerid, GetWeaponModelD(HouseInfo[h][safe_gun][index]), true);
				}
				
				SaveHouse(h);
		    }
		    else if(GetPVarInt(playerid, "safe:dialog") == 2) // положить
		    {
		        new slotid = GetPVarInt(playerid, "safe:gunslot"),
					ammos,
					weaponid,
					input = strval(inputtext),
					h = PlayerInfo[playerid][pHouse],
					index = GetPVarInt(playerid, "safe:index");
					
				GetPlayerWeaponData(playerid, slotid, weaponid, ammos);

				if(ammos-input < 0)
				    return ShowPlayerDialog(playerid, dialog_safe_gun, DIALOG_STYLE_INPUT, "Оружие", "Укажите количество патронов, которое хотите положить:", "Далее", "Назад");

				SetPlayerAmmo(playerid, weaponid, ammos-input);
				HouseInfo[h][safe_gun][index] = weaponid;
				HouseInfo[h][safe_ammunitions][index] = input;
				
				format(stringer, sizeof(stringer), "Вы положили в сейф %s и патроны к нему в количестве %d штук", weapon_names[weaponid], input);
				SendClientMessage(playerid, -1, stringer);
				
			    ShowLocalSafe(playerid, 0, false);
       			ShowLocalSafe(playerid, GetWeaponModelD(HouseInfo[h][safe_gun][index]), true);

				SaveHouse(h);
		    }
		    else // доложить
		    {
		        new slotid = GetPVarInt(playerid, "safe:gunslot"),
					ammos,
					weaponid,
					input = strval(inputtext),
					h = PlayerInfo[playerid][pHouse],
					index = GetPVarInt(playerid, "safe:index");

				GetPlayerWeaponData(playerid, slotid, weaponid, ammos);

				if(ammos-input < 0)
				    return ShowPlayerDialog(playerid, dialog_safe_gun, DIALOG_STYLE_INPUT, "Оружие", "Укажите количество патронов, которое хотите положить:", "Далее", "Назад");

				SetPlayerAmmo(playerid, weaponid, ammos-input);
				HouseInfo[h][safe_ammunitions][index] += input;

				format(stringer, sizeof(stringer), "Вы доложили в сейф патроны к %s в количестве %d штук", weapon_names[weaponid], input);
				SendClientMessage(playerid, -1, stringer);

			    ShowLocalSafe(playerid, 0, false);
       			ShowLocalSafe(playerid, GetWeaponModelD(HouseInfo[h][safe_gun][index]), true);

				SaveHouse(h);
		    }
		    DeletePVar(playerid, "safe:dialog");
		}
		case dialog_safe_money:
		{
		    if(!response)
		    {
		        DeletePVar(playerid, "safe:dialog");
		        DeletePVar(playerid, "safe:gunslot");
		        ShowLocalSafe(playerid, 1212, true);
		        return 1;
		    }

		    if(!strval(inputtext))
		    {
		        format(stringer, sizeof(stringer), "{FFFFFF}Деньги ($%d)", HouseInfo[PlayerInfo[playerid][pHouse]][safe_money]);
				return ShowPlayerDialog(playerid, dialog_safe_money, DIALOG_STYLE_INPUT, stringer, "Укажите количество денег:", "Далее", "Назад");
		    }
		    
	        new	input = strval(inputtext),
				h = PlayerInfo[playerid][pHouse];

		    if(GetPVarInt(playerid, "safe:dialog") == 1) // взять
		    {
				if(input > HouseInfo[h][safe_money])
				{
			        format(stringer, sizeof(stringer), "{FFFFFF}Деньги ($%d)", HouseInfo[PlayerInfo[playerid][pHouse]][safe_money]);
					return ShowPlayerDialog(playerid, dialog_safe_money, DIALOG_STYLE_INPUT, stringer, "Укажите количество изымаемых денег:", "Далее", "Назад");
				}
				PlayerInfo[playerid][pMoney] += input;
				HouseInfo[h][safe_money] -= input;
				UpdatePlayerData(playerid, "Money", PlayerInfo[playerid][pMoney]);
				
				ShowLocalSafe(playerid, 0, false);
				ShowLocalSafe(playerid, 1212, true);
				
				format(stringer, sizeof(stringer), "Вы взяли из сейфа %d$", input);
				SendClientMessage(playerid, -1, stringer);
				
				SaveHouse(h);
		    }
		    else // положить
		    {
				if(input > PlayerInfo[playerid][pMoney])
				{
			        format(stringer, sizeof(stringer), "{FFFFFF}Деньги ($%d)", HouseInfo[PlayerInfo[playerid][pHouse]][safe_money]);
					return ShowPlayerDialog(playerid, dialog_safe_money, DIALOG_STYLE_INPUT, stringer, "Укажите количество сохраняемых денег:", "Далее", "Назад");
				}
				PlayerInfo[playerid][pMoney] -= input;
				HouseInfo[h][safe_money] += input;
				UpdatePlayerData(playerid, "Money", PlayerInfo[playerid][pMoney]);

				ShowLocalSafe(playerid, 0, false);
				ShowLocalSafe(playerid, 1212, true);
				
				format(stringer, sizeof(stringer), "Вы положили в сейф %d$", input);
				SendClientMessage(playerid, -1, stringer);

				SaveHouse(h);
		    }
		    DeletePVar(playerid, "safe:dialog");
		}
		case dialog_safe_drugs:
		{
		    ShowLocalSafe(playerid, 1578, true);
		    
		    return DeletePVar(playerid, "safe:dialog");
		}
		case dialog_safe_materials:
		{
		    ShowLocalSafe(playerid, 1579, true);
		    
		    return DeletePVar(playerid, "safe:dialog");
		}
	}
	return 1;
}
