import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, OneToMany } from 'typeorm';
import { User } from './user.entity';
import { PreKey } from './prekey.entity';

@Entity('devices')
export class Device {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    deviceId: number; // Signal device ID (usually 1 for primary)

    @Column()
    identityPublicKey: string; // Base64 encoded

    @Column()
    signedPreKeyId: number;

    @Column()
    signedPreKeyPublic: string; // Base64

    @Column()
    signedPreKeySignature: string; // Base64

    @ManyToOne(() => User, (user) => user.devices)
    user: User;

    @OneToMany(() => PreKey, (preKey) => preKey.device)
    preKeys: PreKey[];

    @CreateDateColumn()
    createdAt: Date;

    @Column({ type: 'timestamp', nullable: true })
    lastSeen: Date;
}
