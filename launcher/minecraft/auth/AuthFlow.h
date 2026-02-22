#pragma once

#include <QString>
#include <memory>

class MinecraftAccount;

struct AuthSession {
    bool MakeOffline(QString offline_playername);
    void MakeDemo(QString name, QString uuid);

    QString serializeUserProperties();

    enum Status {
        Undetermined,
        RequiresOAuth,
        RequiresPassword,
        RequiresProfileSetup,
        PlayableOffline,
        PlayableOnline,
        GoneOrMigrated
    } status = Undetermined;

    // combined session ID
    QString session;
    // volatile auth token
    QString access_token;
    // profile name
    QString player_name;
    // profile ID
    QString uuid;
    // 'legacy' or 'mojang', depending on account type
    QString user_type;
    // Did the auth server reply?
    bool auth_server_online = false;
    // Did the user request online mode?
    bool wants_online = true;

    // Is this a demo session?
    bool demo = false;

    // Does authentication confirm ownership of Minecraft?
    bool ownMinecraft = true;
};

using AuthSessionPtr = std::shared_ptr<AuthSession>;
