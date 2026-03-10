import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { User } from './auth/entities/user.entity';
import { Invitation } from './auth/entities/invitation.entity';
import { Device } from './auth/entities/device.entity';
import { PreKey } from './auth/entities/prekey.entity';

@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
        }),
        TypeOrmModule.forRoot({
            type: 'postgres',
            url: process.env.DATABASE_URL,
            entities: [User, Invitation, Device, PreKey],
            synchronize: true, // Set to false in production
        }),
        AuthModule,
    ],
    controllers: [AppController],
    providers: [AppService],
})
export class AppModule { }
