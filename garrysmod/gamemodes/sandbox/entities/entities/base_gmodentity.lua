
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false

if ( CLIENT ) then

	function ENT:BeingLookedAtByLocalPlayer()

		if ( LocalPlayer():GetEyeTrace().Entity != self ) then return false end
		if ( LocalPlayer():GetViewEntity() == LocalPlayer() && LocalPlayer():GetShootPos():Distance( self:GetPos() ) > 256 ) then return false end
		if ( LocalPlayer():GetViewEntity() != LocalPlayer() && LocalPlayer():GetViewEntity():GetPos():Distance( self:GetPos() ) > 256 ) then return false end

		return true

	end

	function ENT:Think()

		if ( self:BeingLookedAtByLocalPlayer() && self:GetOverlayText() != "" ) then

			AddWorldTip( self:EntIndex(), self:GetOverlayText(), 0.5, self:GetPos(), self.Entity )

			halo.Add( { self }, Color( 255, 255, 255, 255 ), 1, 1, 1, true, true )

		end

	end

end

function ENT:SetOverlayText( text )
	self:SetNWString( "GModOverlayText", text )
end

function ENT:GetOverlayText()

	local txt = self:GetNWString( "GModOverlayText" )

	if ( txt == "" ) then
		return ""
	end

	if ( game.SinglePlayer() ) then
		return txt
	end

	local PlayerName = self:GetPlayerName()

	return txt .. "\n(" .. PlayerName .. ")"

end

function ENT:SetPlayer( ply )

	self.Founder = ply

	if ( IsValid( ply ) ) then

		self:SetNWString( "FounderName", ply:Nick() )
		self.FounderSID = ply:SteamID64()
		self.FounderIndex = ply:UniqueID()

	else

		self:SetNWString( "FounderName", "" )
		self.FounderSID = nil
		self.FounderIndex = nil

	end

end

function ENT:GetPlayer()

	if ( self.Founder == nil ) then

		-- SetPlayer has not been called
		return NULL

	elseif ( IsValid( self.Founder ) ) then

		-- Normal operations
		return self.Founder

	end

	-- See if the player has left the server then rejoined
	local ply = player.GetBySteamID64( self.FounderSID )
	if ( not IsValid( ply ) ) then

		-- Oh well
		return NULL

	end

	-- Save us the check next time
	self:SetPlayer( ply )
	return ply

end

function ENT:GetPlayerIndex()

	return self.FounderIndex or 0

end

function ENT:GetPlayerSteamID()

	return self.FounderSID or ""

end

function ENT:GetPlayerName()

	local ply = self:GetPlayer()
	if ( IsValid( ply ) ) then
		return ply:Nick()
	end

	return self:GetNWString( "FounderName" )

end
