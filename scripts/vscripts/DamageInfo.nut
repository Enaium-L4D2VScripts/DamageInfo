Msg("Damage Info...");
const configFile = "Damage Info/config";
local configTemplate = {
    infected = true,
    special = true,
    kill = true,
    headshot = true,
    specialKill = true,
    killCount = true,
    lang = "en",
    welcome = false
};

local config = {};

local langTable = [{
    title = "Damage Info",
    damage = "Damage",
    headshot = "Headshot",
    kill = "Kill",
    success = "Success",
    fail = "Fail",
    welcome = "\x03" + "Welcome to use the damage info, if you have any problems, please feedback to me." + "\x04" + "GitHub:Enaium/Steam:Enaium/BiliBili:Enaium" + "\x02" + "Command:/help"
}, {
    title = "伤害信息",
    damage = "伤害",
    headshot = "爆头",
    kill = "击杀",
    success = "成功",
    fail = "失败",
    welcome = "\x03" + "欢迎使用伤害信息,如果有使用问题请反馈给我." + "\x04" + "GitHub:Enaium/Steam:Enaium/BiliBili:Enaium" + "\x02" + "命令:/help"
}];

local lang = {};

local killCount = 0;

config = FileIO.LoadTable(configFile);
if (config == null || config.infected == null || config.special == null || config.kill == null || config.headshot == null || config.specialKill == null || config.killCount == null || config.lang == null || config.welcome == null) {
    config = configTemplate;
}

FileIO.SaveTable(configFile, config);

switch (config.lang) {
    case "en": {
        lang = langTable[0];
        break;
    }
    case "zh": {
        lang = langTable[1];
        break;
    }
    default: {
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
    if (config.infected || entity.GetClassname() == "witch") {
        ClientPrint(attacker, 4, lang.damage + ":" + params.amount);
    }
}

function Notifications::OnDeath::PlayerDeath(entity, attacker, params) {
    if (entity.GetName() != attacker.GetName() && entity.GetName() != "") {
        if (config.specialKill) {
            ClientPrint(null, 5, attacker.GetName() + " " + lang.kill + " " + entity.GetName());
        }
    }
    if (attacker.IsBot()) return;
    local info;
    if (params.headshot) {
        if (config.headshot) {
            info = lang.headshot;
        }
    } else {
        if (config.kill) {
            info = lang.kill;
        }
    }

    killCount++;

    if (config.killCount) {
        info += killCount;
    }
    ClientPrint(attacker, 4, info);
}

function Notifications::OnHurt::PlayerHurt(entity, attacker, params) {
    if (attacker.IsBot() || entity.IsSurvivor()) return;
    if (config.special) {
        ClientPrint(attacker, 4, entity.GetName() + ":" + params.health)
    }
}

local function tobool(text) {
    switch (text) {
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
    local args = split(text, " ");
    switch (args[0]) {
        case "/help": {
            ClientPrint(player, 5, "/help");
            ClientPrint(player, 5, "/lang <en/zh>");
            ClientPrint(player, 5, "/set <infected/special/kill/headshot/specialKill/killCount> <value>");
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
                switch (args[1]) {
                    case "infected": {
                        config.infected = tobool(args[2]);
                        ClientPrint(player, 5, lang.success);
                        FileIO.SaveTable(configFile, config);
                        break;
                    }
                    case "special": {
                        config.special = tobool(args[2]);
                        ClientPrint(player, 5, lang.success);
                        FileIO.SaveTable(configFile, config);
                        break;
                    }
                    case "kill": {
                        config.kill = tobool(args[2]);
                        ClientPrint(player, 5, lang.success);
                        FileIO.SaveTable(configFile, config);
                        break;
                    }
                    case "headshot": {
                        config.headshot = tobool(args[2]);
                        ClientPrint(player, 5, lang.success);
                        FileIO.SaveTable(configFile, config);
                        break;
                    }
                    case "specialKill": {
                        config.specialKill = tobool(args[2]);
                        ClientPrint(player, 5, lang.success);
                        FileIO.SaveTable(configFile, config);
                        break;
                    }
                    case "killCount": {
                        config.killCount = tobool(args[2]);
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
                ClientPrint(player, 5, lang.fail);
            }
            return;
        }
    }
}