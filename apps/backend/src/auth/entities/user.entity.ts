import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, OneToMany } from 'typeorm';
import { Device } from './device.entity';

@Entity('users')
export class User {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ unique: true })
    email: string;

    @Column({ unique: true })
    username: string;

    @Column()
    passwordHash: string;

    @Column({ default: false })
    isVerified: boolean;

    @Column({ default: 'member' })
    role: string;

    @CreateDateColumn()
    createdAt: Date;

    @OneToMany(() => Device, (device) => device.user)
    devices: Device[];
}
