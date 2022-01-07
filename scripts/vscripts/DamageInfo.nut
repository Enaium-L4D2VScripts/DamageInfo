Msg("Damage Info...");
const configFile = "Damage Info/config";
local config = FileIO.LoadTable(configFile);

local langTable = [{
    title = "Damage Info",
    damage = "Damage",
    headshot = "Headshot",
    kill = "Kill",
    success = "Success",
    fail = "Fail",
    welcome = "\x03" + "Welcome to use the damage info, if you have any problems, please feedback to me." + "\x04" + "GitHub:Enaium/Steam:Enaium/BiliBili:Enaium"
}, {
    title = "伤害信息",
    damage = "伤害",
    headshot = "爆头",
    kill = "击杀",
    success = "成功",
    fail = "失败",
    welcome = "\x03" + "欢迎使用伤害信息,如果有使用问题请反馈给我." + "\x04" + "GitHub:Enaium/Steam:Enaium/BiliBili:Enaium"
}];

local lang = {};

if (config == null) {
    config = {
        infectedInfo = true,
        specialInfo = true,
        killInfo = true,
        headshotInfo = true,
        lang = "en",
        welcome = false
    }
    FileIO.SaveTable(configFile, config);
}

switch (config.lang) {
    case "en": {
            lang = langTable[0];
            break;
        }
    case "zh": {
            lang = langTable[1];
            break;
        }
    default:{
            lang = langTable[0];
            break;
        }
}

function Notifications::OnPlayerActivate::Welcome(entity, params) {
    printl(lang.title);
    if (!config.welcome) {
        ClientPrint(entity, 3, lang.welcome);
        config.welcome = true;
        FileIO.SaveTable(configFile, config);
    }
}

function Notifications::OnInfectedHurt::AttackInfected(entity, attacker, params) {
    if (attacker.IsBot()) return;
    if (config.infectedInfo || entity.GetClassname() == "witch") {
        ClientPrint(attacker, 5, lang.damage + ":" + params.amount);
    }
}

function Notifications::OnDeath::InfectedDeath(entity, attacker, params) {
    if (attacker.IsBot()) return;
    if (params.headshot) {
        if (config.headshotInfo) {
            ClientPrint(attacker, 4, lang.headshot);
        }
    } else {
        if (config.killInfo) {
            ClientPrint(attacker, 4, lang.kill);
        }
    }
}

function Notifications::OnHurt::PlayerHurt(entity, attacker, params) {
    if (attacker.IsBot() || entity.IsSurvivor()) return;
    if (config.specialInfo) {
        ClientPrint(attacker, 4, entity.GetName() + ":" + params.health)
    }
}

local function tobool(text) {
    switch(text) {
        case "true": {
            return true;
            break;
        }
        case "false": {
            return false;
            break;
        }
        default: {
            return false;
            break;
        }
    }
}

function Notifications::OnSay::Command(player, text, params) {
    local args = split(text," ");
    switch(args[0]) {
        case "/help": {
            ClientPrint(player, 5, "/help");
            ClientPrint(player, 5, "/lang <en/zh>");
            ClientPrint(player, 5, "/set <infectedInfo/specialInfo/killInfo/headshotInfo> <value>");
            return;
        }
        case "/lang": {
            config.lang = args[1];
            switch (config.lang) {
                case "en":
                    lang = langTable[0];
                    break;
                case "zh":
                    lang = langTable[1];
                    break;
                default:
                    lang = langTable[0];
                break;
            }
            ClientPrint(player, 5, lang.success);
            FileIO.SaveTable(configFile, config);
            return;
        }
        case "/set": {
            if (args[1] != null) {
                switch(args[1]) {
                    case "infectedInfo": {
                        config.infectedInfo = tobool(args[2]);
                        ClientPrint(player, 5, lang.success);
                        FileIO.SaveTable(configFile, config);
                        break;
                    }
                    case "specialInfo": {
                        config.specialInfo = tobool(args[2]);
                        ClientPrint(player, 5, lang.success);
                        FileIO.SaveTable(configFile, config);
                        break;
                    }
                    case "killInfo": {
                        config.killInfo = tobool(args[2]);
                        ClientPrint(player, 5, lang.success);
                        FileIO.SaveTable(configFile, config);
                        break;
                    }
                    case "headshotInfo": {
                        config.headshotInfo = tobool(args[2]);
                        ClientPrint(player, 5, lang.success);
                        FileIO.SaveTable(configFile, config);
                        break;
                    }
                    default: {
                        ClientPrint(player, 5, lang.fail);
                        break;
                    }
                }
            } else {
                ClientPrint(player,5,lang.fail);
            }
            return;
        }
    }
}