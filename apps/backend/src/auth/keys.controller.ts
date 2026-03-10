import { Controller, Post, Get, Body, Param, UseGuards, Request } from '@nestjs/common';
import { KeysService } from './keys.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard'; // I'll create this next

@Controller('keys')
export class KeysController {
    constructor(private readonly keysService: KeysService) { }

    @UseGuards(JwtAuthGuard)
    @Post('upload')
    async uploadKeys(@Request() req, @Body() data: any) {
        return this.keysService.uploadKeys(req.user.userId, data);
    }

    @UseGuards(JwtAuthGuard)
    @Get(':userId')
    async getPreKeyBundle(@Param('userId') userId: string) {
        return this.keysService.getPreKeyBundle(userId);
    }
}
