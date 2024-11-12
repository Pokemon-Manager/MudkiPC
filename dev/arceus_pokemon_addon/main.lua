require 'structures'
function read(filename, extension)
    local nicknameAddress = 0x58;
    local versionAddress = 0xCE;
    local otNicknameAddress = 0xF8;
    local moveAddress = 0x72;
    local ivAddress = 0x8C;
    local genderSpanAddress = 0x22;
    local evAddress = 0x26;
    if (extension == "pk7") then
        nicknameAddress = 0x40;
        ivAddress = 0x74;
        otNicknameAddress = 0xB0;
        moveAddress = 0x5A;
        evAddress = 0x1E;
        genderSpanAddress = 0x1D;
        versionAddress = 0xDF;
    end

    local pokemon = {
        checksum = ru16(0x06, true),
        ability = ru16(0x14, true),
        abilitySpan = rfield(0x16, {
            { "abilityNumber", 7 },
            { "abilityHidden", 1 }
        }, true),
        speciesID = ru16(0x08, true),
        genderSpan = rfield(genderSpanAddress, {
            { "fatefulEncounter", 1 },
            { "gender",           3 }
        }, true),
        otNickname = rstr16(otNicknameAddress, 0x0C),
        evHp = ru8(evAddress),
        evAtk = ru8(evAddress + 1),
        evDef = ru8(evAddress + 2),
        evSpAtk = ru8(evAddress + 3),
        evSpDef = ru8(evAddress + 4),
        evSpeed = ru8(evAddress + 5),
        exp = ru32(0x10),
        id32 = ru32(0x0C, true),
        tid16 = ru16(0x0C, true),
        sid16 = ru16(0x0E, true),
        move1 = ru16(moveAddress, true),
        move2 = ru16(moveAddress + 2, true),
        move3 = ru16(moveAddress + 4, true),
        move4 = ru16(moveAddress + 6, true),
        version = ru8(versionAddress)
    };
    local ivSpan = rfield(ivAddress,
        {
            { "ivHp",        5 },
            { "ivAtk",       5 },
            { "ivDef",       5 },
            { "ivSpeed",     5 },
            { "ivSpAtk",     5 },
            { "ivSpDef",     5 },
            { "isEgg",       1 },
            { "isNicknamed", 1 }
        }, true);
    pokemon.ivSpan = ivSpan;
    if (pokemon.ivSpan.isNicknamed == true) then
        pokemon.nickname = cleanstr(rstr16(nicknameAddress, 0x0C));
    end

    if validate(pokemonVaildator, pokemon) then
        return pokemon;
    end
end

function write(filename, data)
end

defaultPokemon = {
    checksum = 1,
    ability = 1,
    abilitySpan = {
        abilityNumber = 1,
        abilityHidden = 1
    },
    speciesID = 1,
    genderSpan = {
        fatefulEncounter = 1,
        gender = 1
    },
    otNickname = "",
    evHp = 0,
    evAtk = 0,
    evDef = 0,
    evSpAtk = 0,
    evSpDef = 0,
    evSpeed = 0,
    exp = 0,
    id32 = 0,
    tid16 = 0,
    sid16 = 0,
    move1 = 1,
    move2 = 1,
    move3 = 1,
    move4 = 1,
    version = 0
}
